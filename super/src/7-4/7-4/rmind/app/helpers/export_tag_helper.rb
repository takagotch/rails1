module ExportTagHelper
  include Amrita2View::Helper

  def ical_url
    tag = self
    eval_in_view_without_escape do
      url_for(:action=>:ical, :id=>tag.private_key.key)
    end
  end
end
