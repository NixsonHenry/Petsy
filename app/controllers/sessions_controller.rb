class SessionsController < ApplicationController

  skip_before_action :only_signed_in, only: [:new, :create]

  before_action :only_signed_out, only: [:new, :create]


  def new
  end  

  def create
    # Tout d'abord, on va creer une variable 'user_params' pour recuperer les parametres de l'utilisateur
    user_params = params.require(:user)
    # Je veux l'utilisateur qui correspond a ce qui est taper
    @user = User.where(username: user_params[:username]).or(User.where(email: user_params[:username])).first
    if @user and @user.authenticate(user_params[:password])
    session[:auth] = @user.to_session
    redirect_to profil_path, success: 'The Connection is successful'
    else
      redirect_to new_session_path, danger: 'Incorrect Identifiers'
    end
  
  end 


  def destroy
    session.destroy
    redirect_to new_session_path, success: 'You are now deconnected'
  end

  
end
