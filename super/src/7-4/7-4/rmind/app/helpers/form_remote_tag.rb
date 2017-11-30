
class FormRemoteTag < Amrita2::Macro::Base
  TemplateText = <<-END_OF_TEMPLATE
      <%%= form_remote_tag(<%= $_[:url].inspect %>) %%>
        <<:contents>>
      <%%= '</form>' %%>

  END_OF_TEMPLATE

  def macro_data(element)
    root = element.as_amrita_dictionary
    url = element.search("url").first
    contents = element.children.find_all do |c|
      c != url
    end

    ret = {
      :url => url ? url.as_amrita_dictionary : {},
      :contents => Amrita2::SanitizedString[contents]
    }
    ret
  end
end

