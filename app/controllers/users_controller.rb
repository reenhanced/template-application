class UsersController < ApplicationController
  before_filter :authenticate_user!

  def show
    @user = User.find(params[:id])
  end

  def edit
    @user = current_user
    render "devise/registrations/edit"
  end

  # https://github.com/plataformatec/devise/blob/master/app/controllers/devise/registrations_controller.rb
  def update
    @user = current_user

    if @user.update_with_password(params[:user])
      sign_in :user, @user, :bypass => true
      flash[:notice] = I18n.t "users.update.success"
      redirect_to edit_user_path(@user)
    else
      @user.clean_up_passwords
      flash[:failure] = I18n.t "users.update.error"
      render "devise/registrations/edit"
    end
  end
end
