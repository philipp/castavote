# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  include AuthenticatedSystem  
  helper :all # include all helpers, all the time
  before_filter :check_preallowed_for_current_request
  before_filter :has_write_access, :only => [:edit, :destroy, :create, :update, :new]
  
  

  # See ActionController::RequestForgeryProtection for details
  # Uncomment the :secret if you're not using the cookie session store
  protect_from_forgery # :secret => '4f40a200252c42b12d2efc05f4568e5c'
  
  # See ActionController::Base for details 
  # Uncomment this to filter the contents of submitted sensitive data parameters
  # from your application log (in this case, all fields with names like "password"). 
  # filter_parameter_logging :password
  
  private
  
  def check_preallowed_for_current_request
    if !current_user.blank?    
      @user_has_access_to_resource = current_user.has_access_to_resource?(request.request_uri)     
      @company = current_user.companies.find(params[:company_id])            if !params[:company_id].blank?
      @user_can_manage_company = current_user.can_manage_company?(@company)  if !@company.blank?      
    end
  end
  

  def has_write_access
    return if skip_authorization?
    redirect_to insufficient_path if !@user_can_manage_company           
  end

  # defines resources that never require the authentication
    def skip_authorization?
      return true if request.path == new_sessions_path
      return true if request.path == sessions_path and request.method == :post
      return true if request.path == "/signup"
      return true if request.path == "/logout"
      return true if request.path == new_company_path
      return true if request.path == companies_path and request.method == :post
      return true if request.path == new_user_path
      return true if request.path == users_path and request.method == :post
      false
    end


end
