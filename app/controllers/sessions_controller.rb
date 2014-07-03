class SessionsController < ApplicationController
  def create
    @user = User.find_or_create_with_omniauth(auth_hash)
    session[:user_id] = @user.id
    redirect_to '/'
  end

  def destroy
    session[:user_id] = nil
    redirect_to :root
  end

  protected

  def auth_hash
    request.env['omniauth.auth']
  end
end