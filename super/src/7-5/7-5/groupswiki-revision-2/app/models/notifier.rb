class Notifier < ActionMailer::Base

  def signup_thanks(wiki)
    recipients [wiki.email, 'bnolan@gmail.com']
    from  "groupswiki@gmail.com"
    subject "Details for your wiki"
    body :domain => wiki.domain
  end
  
end