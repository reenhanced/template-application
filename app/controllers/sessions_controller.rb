class Users::SessionsController < Devise::SessionsController
  def new
    if current_user
      redirect_to root_path
    else
      clean_up_passwords(build_resource)
      render_with_scope :new
    end
  end
end

