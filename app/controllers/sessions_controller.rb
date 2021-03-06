class SessionsController < ApplicationController

  def new
    flash[:notice] = nil
  end

  def create
    user = User.find_by(email: params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password])
      sign_in user
      redirect_back_or :controller => :users, :action => :home
    else
      flash[:notice] = 'Invalid email/password combination'
      render 'new'
    end
  end

  def destroy
    sign_out
    redirect_to root_path
  end
end