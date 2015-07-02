class PagesController < ApplicationController
  include HighVoltage::StaticPage
  layout 'static_pages'
end
