class HomeController < ApplicationController
  #this method is a delegator that redirects to other controllers
  def index
    if current_user.companies.size == 1
      redirect_to company_url(current_user.companies.first)
    else
      redirect_to company_url
    end
  end
end
