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
require 'active_support/all'
require 'action_view'
include ActionView::Helpers::DateHelper
distance_of_time_in_words(Time.now, Time.local(2010, 12, 25))
distance_of_time_in_words(Time.now, Time.now + 33, false)
distance_of_time_in_words(Time.now, Time.now + 33, true)
time_ago_in_words(Time.local(2009, 12, 25))
