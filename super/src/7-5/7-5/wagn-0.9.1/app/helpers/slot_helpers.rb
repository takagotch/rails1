module SlotHelpers  
  def render_diff(card, *args)
    @renderer.render_diff(card, *args)
  end
 
  
  def notice 
    %{<span class="notice">#{controller.notice}</span>}
  end

  def id(area="") 
    area, id = area.to_s, ""  
    id << "javascript:#{get(area)}"
  end  
  
  def parent
    "javascript:getSlotSpan(getSlotSpan(this).parentNode)"
  end                       
   
  def nested_context?
    context.split('_').length > 2
  end
   
  def get(area="")
    area.empty? ? "getSlotSpan(this)" : "getSlotElement(this, '#{area}')"
  end
   
  def selector(area="")   
    "getSlotFromContext('#{context}')";
  end
 
  def card_id
    (card.new_record? && card.name)  ? Cardname.escape(card.name) : card.id
  end

  def editor_id(area="")
    area, eid = area.to_s, ""
    eid << context
    eid << (area.blank? ? '' : "-#{area}")
  end

  def url_for(url, args=nil)
    url = "javascript:'/#{url}" 
    url << "/#{card_id}" if (card and card_id)
    url << "?context='+getSlotContext(this)"
    url << ("+'"+ args.map{|k,v| "&#{k}=#{v}"}.join('') + "'") if args
    url
  end

  def header 
    @template.render :partial=>'card/header', :locals=>{ :card=>card, :slot=>self }
  end

  def menu   
    if card.phantom?
      return %{<div class="card-menu faint">Auto</div>\n}
    end
    menu = %{<div class="card-menu">\n}
  	menu << link_to_menu_action('view')
  	menu << link_to_menu_action('edit') 
  	menu << link_to_menu_action('changes')
  	menu << link_to_menu_action('options') 
  	menu << link_to_menu_action('related') 
    menu << "</div>"
  end

  def footer 
     cache_action('footer') { render_partial( 'card/footer' ) }
  end

  def option( args={}, &proc)
    args[:label] ||= args[:name]
    args[:editable]= true unless args.has_key?(:editable)
    self.options_need_save = true if args[:editable]
    concat %{<tr>
      <td class="inline label"><label for="#{args[:name]}">#{args[:label]}</label></td>
      <td class="inline field">
    }, proc.binding
    yield
    concat %{
      </td>
      <td class="help">#{args[:help]}</td>
      </tr>
    }, proc.binding
  end

  def option_header(title)
    %{<tr><td colspan="3" class="option-header"><h2>#{title}</h2></td></tr>}
  end

  def link_to_menu_action( to_action)
    link_to_action to_action.capitalize, to_action, {},
      :class=> (action==to_action ? 'current' : '')
  end

  def link_to_action( text, to_action, remote_opts={}, html_opts={})
    link_to_remote text, remote_opts.merge(
      :url=>url_for("card/#{to_action}"),
      :update => id
    ), html_opts
  end

  def button_to_action( text, to_action, remote_opts={}, html_opts={})
    button_to_remote text, remote_opts.merge(
      :url=>url_for("card/#{to_action}"),
      :update => id
    ), html_opts
  end

  def name_field(form,options={})
    text = %{<span class="label"> card name:</span>\n}
    text << form.text_field( :name, {:size=>40, :class=>'field card-name-field'}.merge(options))
  end

  def cardtype_field(form,options={})
    text = %{<span class="label"> card type:</span>\n} 
    text << @template.select_tag('card[type]', cardtype_options_for_select(card.type), options) 
  end

  def update_cardtype_function(options={})
    fn = ['File','Image'].include?(card.type) ? 
            "Wagn.onSaveQueue['#{context}'].clear(); " :
            "Wagn.runQueue(Wagn.onSaveQueue['#{context}']); "      
    if @card.hard_content_template
      #options.delete(:with)
    end
    fn << remote_function( options )   
  end
     
  def js_content_element 
    @card.hard_content_template ? "" : ",getSlotElement(this,'form').elements['card[content]']" 
  end

  def content_field(form,options={})   
    self.form = form              
    @nested = options[:nested]
    pre_content =  (card and !card.new_record?) ? form.hidden_field(:current_revision_id, :class=>'current_revision_id') : ''
    pre_content + self.render_partial( custom_partial_for('editor'), options )
  end                          
 
  def save_function 
    "warn('running #{context} queue'); if (Wagn.runQueue(Wagn.onSaveQueue['#{context}'])) { this.form.onsubmit() }"
  end

  def cancel_function 
    "Wagn.runQueue(Wagn.onCancelQueue['#{context}']);"
  end


  def editor_hooks(hooks)
    # it seems as though code executed inline on ajax requests works fine
    # to initialize the editor, but when loading a full page it fails-- so
    # we run it in an onLoad queue.  the rest of this code we always run
    # inline-- at least until that causes problems.     
    hook_context = @nested ? context.split('_')[0..-2].join('_') : context
  
    code = ""
    if hooks[:setup]
      code << "Wagn.onLoadQueue.push(function(){\n" unless request.xhr?
      code << hooks[:setup]
      code << "});\n" unless request.xhr?
    end
    if hooks[:save]  
      code << "warn('adding to #{hook_context} save queue');"
      code << "if (typeof(Wagn.onSaveQueue['#{hook_context}'])=='undefined') {\n"
      code << "  Wagn.onSaveQueue['#{hook_context}']=$A([]);\n"
      code << "}\n"
      code << "Wagn.onSaveQueue['#{hook_context}'].push(function(){\n"
      code << "warn('running #{hook_context} save hook');"
      code << hooks[:save]
      code << "});\n"
    end
    if hooks[:cancel]
      code << "if (typeof(Wagn.onCancelQueue['#{hook_context}'])=='undefined') {\n"
      code << "  Wagn.onCancelQueue['#{hook_context}']=$A([]);\n"
      code << "}\n"
      code << "Wagn.onCancelQueue['#{hook_context}'].push(function(){\n"
      code << hooks[:cancel]
      code << "});\n"
    end
    javascript_tag code
  end
end  