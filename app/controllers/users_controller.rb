class UsersController < ApplicationController

    #Je vais creer un utilisateur qui sera un nouvelle utilisateur et je cree la vue qui correspond a cette action
    

    skip_before_action :only_signed_in, only: [:new, :create, :confirm]

    before_action :only_signed_out, only: [:new, :create, :confirm]



    def new
        @user = User.new
    end


    def create
        user_params = params.require(:user).permit(:username, :email, :password, :password_confirmation)
        @user = User.new(user_params)
        @user.recover_password = nil
        
        if @user.valid?
            @user.save
            UserMailer.confirm(@user).deliver_now
            redirect_to new_user_path, success: 'your account has been created, you have received a confirmation email to confirm your account'

            #render 'new'
        else
            render 'new'
        end
    end


    def confirm
        # Tout d'abord, on recupere l'utilisateur
        @user = User.find(params[:id])
        # On verifie le 'confirm_token' qui est passe en parametre correspond au confirm_token qui est stocke dans la base de donnee
        if @user.confirmation_token == params[:token]
            @user.update_attributes(confirmed: true, confirmation_token: nil)
            @user.save(validate: false)
            # Mon utilisateur a un compte valide; je peux le connecter et pour gerer la connection j'utilise la session
            # je cree une clef appeler 'auth' et je mets 'id: @user.id' de l'utilisateur
            # Creons une methode permettant de convertir l'utilisateur en session
            # session[:auth] = [id: @user.id]
            session[:auth] = @user.to_session
            redirect_to profil_path, success: 'Your account has been confirmed'

        else
            redirect_to new_user_path, danger: 'This token seems invalid'
        end
    end



    def edit

        #@user = User.find(session[:auth]['id'])
        @user = current_user
    end


    def update

        @user = current_user
        user_params = params.require(:user).permit(:username, :firstname, :lastname, :avatar_file, :email)
        #puts user_params[:avatar].inspect
        if @user.update(user_params)
            redirect_to profil_path, success: 'Your account has been updated'
            
        else

            render :edit
    end

end


end