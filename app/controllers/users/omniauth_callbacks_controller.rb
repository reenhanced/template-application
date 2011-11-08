class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def facebook
    debugger
    @user = User.find_for_facebook_oauth(env["omniauth.auth"], current_user)
    puts "Omniauth env is:"
puts env["omniauth.auth"]
    if @user
      flash[:notice] = I18n.t "devise.omniauth_callbacks.success", :kind => "Facebook"
      @user.confirm!
      sign_in_and_redirect @user, :event => :authentication
    else
      flash[:alert] = I18n.t "devise.omniauth_callbacks.error",
                             :kind => "Facebook",
                             :default => "You must be invited from a Railzbiz admin"
      redirect_to new_user_registration_url
    end
  end

  def passthru
      render :file => "#{Rails.root}/public/404.html", :status => 404, :layout => false
  end
end

