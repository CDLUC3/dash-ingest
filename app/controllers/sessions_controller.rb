class SessionsController < ApplicationController
  def create
    user = User.from_omniauth(env["omniauth.auth"])
    session[:user_id] = user.id
    user.institution_id = session['institution_id']
    redirect_to current_user.institution/records_path, notice: "Signed in!"
  end

  def destroy
    session[:user_id] = nil
    redirect_to records_path
  end
end

