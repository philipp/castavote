# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  include AuthenticatedSystem  
  helper :all # include all helpers, all the time
  before_filter :check_preallowed_for_current_request
  before_filter :has_access, :only => [:edit, :destroy, :create, :update, :new]
  
  

  # See ActionController::RequestForgeryProtection for details
  # Uncomment the :secret if you're not using the cookie session store
  protect_from_forgery # :secret => '4f40a200252c42b12d2efc05f4568e5c'
  
  # See ActionController::Base for details 
  # Uncomment this to filter the contents of submitted sensitive data parameters
  # from your application log (in this case, all fields with names like "password"). 
  # filter_parameter_logging :password
  
  private
  
  def check_preallowed_for_current_request
     @company = current_user.companies.find(params[:company_id]) if !current_user.blank? && !params[:company_id].blank?
    if(current_user and @company and !current_user.can_manage_company?(@company))      
      session[:has_access] = true
    else
      session[:has_access] = false      
    end
  end
  

  def has_access
   if(session[:has_access])      
     redirect_to insufficient_path
   end
  end
end
