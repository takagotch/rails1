class CommentDrop < BaseDrop
  include Mephisto::Liquid::UrlMethods
  include WhiteListHelper
  
  timezone_dates :published_at, :created_at
  liquid_attributes.push(*[:author, :author_email, :author_ip, :title])

  def initialize(source)
    super
    @liquid.update 'is_approved' => @source.approved?, 'body' => white_list(@source.body_html)
  end
  
  def author_url
    return nil if source.author_url.blank?
    @source.author_url =~ /^https?:\/\// ? @source.author_url : "http://" + @source.author_url
  end

  def url
    @url ||= absolute_url(@source.site.permalink_for(@source))
  end

  def author_link
    @source.author_url.blank? ? "<span>#{CGI::escapeHTML(@source.author)}</span>" : %Q{<a href="#{CGI::escapeHTML author_url}">#{CGI::escapeHTML @source.author}</a>}
  end
end