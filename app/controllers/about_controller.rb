class AboutController < ApplicationController
  layout "application"

  before_filter :set_tab

  def set_tab
    @@selected = "about"  
  end
  
  def index
    
  end
end
