ActionController::Routing::Routes.draw do |map|
  map.home '', :controller => 'pages', :action => 'homepage'

  map.resources :pages, :member => {:revisions => :get}
  map.resources :wikis, :member => {:users => :any, :layout => :any, :export => :any}
  map.resources :users
  map.resources :attachments
  map.resources :revisions

  map.edit_wiki '/signup', :controller => 'wikis', :action => 'new'

  map.page_revisions '/pages/:id/revisions', :controller => 'pages', :action => 'revisions'
  map.revert_page '/pages/:id/revert/:version', :controller => 'pages', :action => 'revert'
  
  map.edit_wiki '/wiki/settings', :controller => 'wikis', :action => 'edit'
  map.export_wiki '/wiki/export', :controller => 'wikis', :action => 'export'
  map.update_wiki '/wiki/update', :controller => 'wikis', :action => 'update'
  
  map.search '/search', :controller => "pages"

  map.logged_in '/logged_in', :controller => "auth", :action => 'index'

  map.logout '/logout', :controller => "auth", :action => 'logout'
  map.login '/login', :controller => "auth", :action => 'login'
  map.signup '/signup', :controller => "auth", :action => 'signup'
end
