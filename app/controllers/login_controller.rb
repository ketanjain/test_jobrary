class LoginController < ApplicationController
  USERID = 'viper'
  PASSWORD = "viper"

  def index
    @error_msg = nil
  end

  def create
    respond_to do |format|
      if params[:login_password] == PASSWORD && params[:login_id] = USERID
        logger.info "Logged in"
        session[:authorized] = true
        format.html {  redirect_to list_analysis_path }
      else
        logger.error "Invalid password #{params[:password]}"
        @error_msg = INVALID_LOGIN_ERROR
        format.html {  render :action=>'index' }
      end
    end
  end

  def logout
    session[:authorized] = nil
    respond_to do |format|
        format.html {  redirect_to root_url }
    end
  end
end
