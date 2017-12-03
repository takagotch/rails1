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
class PicturesController < ApplicationController
  def new
    @picture = Picture.new
  end
  # . . .

  def create
    @picture = Picture.new(params[:picture])
    if @picture.save
      redirect_to(@picture)
    else
      render(action: :new)
    end
  end

  def show
    @picture = Picture.find(params[:id])
  end

  def download
    @picture = Picture.find(params[:picture_id])
    send_data(@picture.data,
              filename: @picture.name,
              type: @picture.content_type,
              disposition: "inline")
  end
end
