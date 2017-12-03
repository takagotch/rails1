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
class CreatePictures < ActiveRecord::Migration
  def self.up
    create_table :pictures do |t|
      t.string :comment
      t.string :name
      t.string :content_type
      # MySQLを使う場合には、各データのデフォルトが64Kになっている。
      # そのため、これを拡張するために明確なサイズを与える必要がある。
      t.binary :data, :limit => 1.megabyte
    end
  end

  def self.down
    drop_table :pictures
  end
end
