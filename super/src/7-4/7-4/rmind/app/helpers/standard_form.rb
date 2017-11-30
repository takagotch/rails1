
class StandardForm < Amrita2::Macro::Base
  TemplateText = <<-END_OF_TEMPLATE
    <<fieldset<
      <<legend:title>>
      <%%= form_tag(<%= $_[:url].inspect %>) %%>
        <<:header>>
        <<p:items<
          <<label:label|Attr[:for]<
            <<:text>>:
          <<:input>>
        <<:fotter>>
      <%%= '</form>' %%>

  END_OF_TEMPLATE

  def macro_data(element)
    root = element.as_amrita_dictionary
    record = root[:record].intern
    title = element.search("form_title").first
    url = element.search("url").first
    header = element.search("header").first
    items = element.search("tr").collect do |tr|
      tr_to_data(record, tr)
    end
    fotter = element.search("fotter").first

    ret = {
      :title => title.contents,
      :record => record,
      :url => url ? url.as_amrita_dictionary : {},
      :header => header.contents,
      :items => items,
      :fotter => fotter.contents
    }
    ret
  end

  def tr_to_data(record, tr)
    label = tr.search("th").first
    td = tr.search("td").first
    input = td_to_input(record, td) || { }
    {
      :label => {
        :for => "#{record}_#{input[:field_id]}",
        :text => label.contents.strip,
      },
      :input => input[:input]
    }
  end

  def td_to_input(record, td)
    x = td.children.find { |c| c.kind_of?(Hpricot::Elem) }
    raise "input was not found in <td>" unless x
    attr = x.as_amrita_dictionary
    field_id = attr.delete(:id)
    input =  case x.name
             when "text"
               "<%= text_field #{record.to_s.inspect}, #{field_id.to_s.inspect}, #{attr.inspect} %>"
             when "text_area"
               "<%= text_area #{record.to_s.inspect}, #{field_id.to_s.inspect}, #{attr.inspect} %>"
             when "field"
               x.contents
             else
               raise "unknown input field #{x.name} "
             end
    {
      :input => Amrita2::SanitizedString[input],
      :field_id => field_id
    }
  end
end

