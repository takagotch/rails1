# encoding: utf-8
#---
# Excerpted from "Agile Web Development with Rails, 4th Ed.",
# published by The Pragmatic Bookshelf.
# Copyrights apply to this code. It may not be used to create training material, 
# courses, books, articles, and the like. Contact us if you are in doubt.
# We make no guarantees that this code is fit for any purpose. 
# Visit http://www.pragmaticprogrammer.com/titles/rails4 for more book information.
#
# 日本語版については http://ssl.ohmsha.co.jp/cgi-bin/menu.cgi?ISBN=978-4-274-06866-9
#---
class ArticleSweeper < ActionController::Caching::Sweeper

  observe Article

  # 新しい記事を作成した場合、公開記事のリストを再生成しなければならない
  def after_create(article)
    expire_public_page
  end

  # 既存の記事を更新した場合、記事のキャッシュされたバージョンは古くなっている
  def after_update(article)
    expire_article_page(article.id)
  end

  # ページを削除した場合、公開記事のリストを更新し、記事のキャッシュを削除する必要がある
  def after_destroy(article)
    expire_public_page
    expire_article_page(article.id)
  end

  private

  def expire_public_page
    expire_page(:controller => "content", :action => 'public_content')
  end

  def expire_article_page(article_id)
    expire_action(:controller => "content", 
                  :action     => "premium_content",
                  :id         => article_id)
  end
end
