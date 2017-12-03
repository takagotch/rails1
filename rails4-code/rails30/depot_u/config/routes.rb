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
require './app/store'
Depot::Application.routes.draw do
  match 'store' => StoreApp.new
  get 'admin' => 'admin#index'
  controller :sessions do
    get  'login' => :new
    post 'login' => :create
    delete 'logout' => :destroy
  end
  scope '(:locale)' do
    resources :users
    resources :orders do
      resources :line_items
    end
    resources :line_items
    resources :carts
    resources :products do
      get :who_bought, :on => :member
    end
    root :to => 'store#index', :as => 'store'
  end
end
