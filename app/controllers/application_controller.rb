class ApplicationController < ActionController::Base


    protect_from_forgery with: :exception

    before_action :only_signed_in

    add_flash_types :success, :danger

    helper_method :current_user, :user_signed_in?

    private

    def only_signed_in

        if !user_signed_in?
        #if !current_user
        #if !session[:auth] || !session[:auth]['id']
            redirect_to new_user_path, danger: 'You cannot access to this page'
        end
    end


    def user_signed_in?

        # Si c'est different de nil l'utilisateur est connecte sinon, l'utilisateur n'est pas connecte
        !current_user.nil?
    end

    def only_signed_out

        redirect_to profil_path if user_signed_in?
    end



    # Retourne l'utilisateur actuellement connecte

    def current_user

        return nil if !session[:auth] || !session[:auth]['id']
        # Si j'ai deja une variable d'instance qui s'appelle user, tu dois le retourner
        return @_user if @_user
        # @user = User.find(session[:auth]['id'])
        # Je veux trouver un enregistrement par rapport a un champ
        @_user = User.find_by_id(session[:auth]['id'])
    end
end

