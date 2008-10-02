class UsersController < ApplicationController
  

  # render new.rhtml
  def new
    @user = User.new
  end
 
  def create
    logout_keeping_session!
    @user = User.new(params[:user])
    success = @user && @user.save
    if success && @user.errors.empty?
            # Protects against session fixation attacks, causes request forgery
      # protection if visitor resubmits an earlier form using back
      # button. Uncomment if you understand the tradeoffs.
      # reset session
      self.current_user = @user # !! now logged in
      if(current_user.preallowed_id == nil || current_user.preallowed_id == 0)
        current_user.add_to_preallowed 
      end
      
      redirect_back_or_default('/')
      flash[:notice] = "Thanks for signing up!"
    else
      flash[:error]  = "We couldn't set up that account, sorry.  Please try again, or contact an admin (link is above)."
      render :action => 'new'
    end
  end

  def forgot_password
    return unless request.post?
    if @user = User.find_by_email(params[:user][:email])
      @user.forgot_password
      @user.save
      flash[:notice] = "A password reset link has been sent to your email address" 
      redirect_to :controller   => "sessions", :action => "new"
    else
      flash[:error] = "Could not find a user with that email address" 
    end
  end

  #
  #reset password
  def reset_password
    @user = User.find_by_password_reset_code(params[:id])
    #raise if @user.nil?

    return if @user unless params[:user]

    if ((params[:user][:password]  == params[:user][:password_confirmation]) && !params[:user][:password_confirmation].blank?)
      #if (params[:user][:password]  params[:user][:password_confirmation])
      self.current_user = @user #for the next two lines to work
      current_user.password_confirmation = params[:user][:password_confirmation]
      current_user.password = params[:user][:password]
      @user.reset_password
      flash[:notice] = current_user.save ? "Password reset" : "Password not reset"
      redirect_back_or_default('/')
    else
      flash[:error] = "Password mismatch"
    end  

  rescue
    logger.error "Invalid Reset Code entered" 
    flash[:error] = "That is an invalid password reset code. Please check your code and try again." 
    redirect_back_or_default('/')
  end


end
