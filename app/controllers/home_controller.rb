class HomeController < ApplicationController
  #this method is a delegator that redirects to other controllers
  def index
    if (current_user and current_user.companies.size == 1)
      redirect_to company_url(current_user.companies.first)
    elsif current_user
      redirect_to companies_url
    end
  end
end
