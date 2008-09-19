# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  include AuthenticatedSystem  
  helper :all # include all helpers, all the time
  before_filter :has_access, :only => [:edit, :destroy, :create, :update, :new]
  
  

  # See ActionController::RequestForgeryProtection for details
  # Uncomment the :secret if you're not using the cookie session store
  protect_from_forgery # :secret => '4f40a200252c42b12d2efc05f4568e5c'
  
  # See ActionController::Base for details 
  # Uncomment this to filter the contents of submitted sensitive data parameters
  # from your application log (in this case, all fields with names like "password"). 
  # filter_parameter_logging :password
  

  def has_access
    @company = current_user.companies.find(params[:company_id]) if !current_user.blank?
   if(current_user and @company and !current_user.can_manage_company?(@company))      
     redirect_to insufficient_path
   end
  end
end
