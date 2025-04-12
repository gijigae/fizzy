class UsersController < ApplicationController
  require_unauthenticated_access only: %i[ new create ]

  before_action :set_user, only: %i[ show edit update ]
  before_action :set_account_from_join_code, only: %i[ new create ]

  def new
    @user = User.new
  end

  def create
    user = User.create!(user_params)
    start_new_session_for user
    redirect_to root_path
  end

  def show
  end

  def edit
  end

  def update
    @user.update! user_params
    redirect_to @user
  end

  private
    def set_account_from_join_code
      @account = Account.find_by_join_code!(params[:join_code])
    end

    def set_user
      @user = User.active.find(params[:id])
    end

    def user_params
      params.expect(user: [ :name, :email_address, :password, :avatar ])
    end
end
