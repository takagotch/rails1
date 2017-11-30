
class FormTag < Amrita2::Macro::Base
  TemplateText = <<-END_OF_TEMPLATE
      <%%= form_tag(<%= $_[:url].inspect %>, <%= $_[:method].inspect %>) %%>
        <<:contents>>
      <%%= '</form>' %%>

  END_OF_TEMPLATE

  def macro_data(element)
    root = element.as_amrita_dictionary
    url = element.search("url").first
    meth = element.search("method").first
    contents = element.children.find_all do |c|
      c != url and c != meth
    end

    ret = {
      :url => url ? url.as_amrita_dictionary : {},
      :method => meth ? meth.as_amrita_dictionary : {},
      :contents => Amrita2::SanitizedString[contents]
    }
    ret
  end
end

