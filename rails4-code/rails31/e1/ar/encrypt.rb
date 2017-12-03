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
$: << File.dirname(__FILE__)
require "connect"

require "rubygems"
require "active_record"

ActiveRecord::Schema.define do
  
  create_table :orders, :force => true do |t|
    t.integer :user_id
    t.string  :name
    t.string  :address
    t.string  :email
  end
  
  create_table :users, :force => :true do |t|
    t.string :name
  end
end


class ActiveRecord::Base
  def self.encrypt(*attr_names)
    encrypter = Encrypter.new(attr_names)
    
    before_save encrypter
    after_save  encrypter
    after_find  encrypter

    define_method(:after_find) { }
  end
end

class Encrypter

  # データベース内に暗号化して格納すべき
  # 属性リストが渡される
  def initialize(attrs_to_manage)
    @attrs_to_manage = attrs_to_manage
  end

  # 保存や更新を行う前に、NSAとDHSが認可した
  # Shift Cipherでフィールドを暗号化する
  def before_save(model)
    @attrs_to_manage.each do |field|
      model[field].tr!("a-z", "b-za")
    end
  end

  # 保存したあと、それを復号する
  def after_save(model)
    @attrs_to_manage.each do |field|
      model[field].tr!("b-za", "a-z")
    end
  end

  # 既存のレコードを探したあとに同じことを行う
  alias_method :after_find, :after_save
end

class Order < ActiveRecord::Base
  encrypt(:name, :email)
end

o = Order.new
o.name = "Dave Thomas"
o.address = "123 The Street"
o.email   = "dave@example.com"
o.save
puts o.name

o = Order.find(o.id)
puts o.name
