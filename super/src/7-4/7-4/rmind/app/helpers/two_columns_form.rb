
class TwoColumnsForm < Amrita2::Macro::Base
  TemplateText = <<-END
  <<div class="form-padding"<
    <%%
        action = <%= $_[:form] && $_[:form][:action] ? $_[:form][:action].inspect : "url_for"  %>
        method = <%= $_[:form] && $_[:form][:method] ? $_[:form][:method].inspect : "post".inspect  %>
     %%>
    <<form action="$1" method="$2"
           target_filter="NVarForAttr[:action, :method]"<
      <<table<
        <<tr macro:src="rows"
             macro:filter="Attr[:class=>:tr_class]"<
          <<td macro:filter="Attr[:class=>:prompt_class]"<
              <label macro:src="title" />
          <td macro:filter="Attr[:class=>:value_class, :body=>:contents]" />
      <<div class="button-bar"<
        <span macro:src="button_bar">>
  END

  def macro_data(element)
    root = element.as_amrita_dictionary
    form_element = element.search("form").first
    form = form_element.as_amrita_dictionary if form_element
    rows = element.search("tr").collect do |c|
      title, contents = *c.search("td")
      {
        :tr_class => root[:tr_class] || "two_columns",
        :prompt_class => root[:prompt_class] || "prompt",
        :title => title.children.to_s,
        :value_class => root[:value_class]  || "value",
        :contents => Amrita2::SanitizedString[contents.children.to_s],
      }
    end
    {
      :form => form,
      :rows => rows,
      :button_bar => Amrita2::SanitizedString[element.search("button_bar").first.children.to_s]
    }
  end

  #def preprocess_element(mt, element)
    ##mt.set_trace(STDOUT)
    ##p macro_data(element)
    #mt.render_with(macro_data(element))
  #end
end
