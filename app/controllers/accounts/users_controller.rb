class Accounts::UsersController < ApplicationController
  before_action :set_user, only: %i[ update destroy ]
  before_action :ensure_permission_to_administer_user, only:  %i[ update destroy ]

  def index
    @users = User.active
  end

  def update
    @user.update(role_params)
    redirect_to users_path
  end

  def destroy
    @user.deactivate
    redirect_to users_path
  end

  private
    def set_user
      @user = User.active.find(params[:id])
    end

    def ensure_permission_to_administer_user
      head :forbidden unless Current.user.can_administer?(@user)
    end

    def role_params
      { role: params.require(:user)[:role].presence_in(%w[ member admin ]) || "member" }
    end
end
