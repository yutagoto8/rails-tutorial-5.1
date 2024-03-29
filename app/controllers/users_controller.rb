class UsersController < ApplicationController
  before_action :logged_in_user, only: [:index, :edit, :update, :destroy]
  before_action :correct_user,   only: [:edit, :update]
  before_action :admin_user,     only: :destroy

  def show
    @user = User.find(params[:id])
    @microposts = @user.microposts.paginate(page: params[:page])
    # redirect_to root_url and return unless @user.activated?
  end
  
  def new
    @user = User.new
  end

  def create
    # @user = User.new(params[:user]) これだと脆弱性があるため使えない
    @user = User.new(user_params)
    if @user.save
      # log_in @user
      # flash[:success] = "Welcome to the Sample App!"
      # redirect_to @user
      # 上記のやつは有効化なくいきなり使えるようにしている
      @user.send_activation_email
      # UserMailer.account_activation(@user).deliver_now
      flash[:info] = "Please check your email to activate your account."
      redirect_to root_url
    else
      render 'new'
    end
  end

  def index
    @users = User.where(activated: true).paginate(page: params[:page])
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update_attributes(user_params)
      flash[:success] = "Profile updated"
      redirect_to @user
    else
      render 'edit'
    end
  end

  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "User deleted"
    redirect_to users_url
  end

  private
  
    def user_params
      params.require(:user).permit(:name, :email, :password, :password_confirmation
      # , :admin adminを渡すとweb経由で渡ってしまい、テストがREDになる
      )
    end

    # ログインはしているが編集しようとしているユーザーが自分でないときの処理
    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_url) unless current_user?(@user)
    end

    # 管理者かの確認
    def admin_user
      redirect_to(root_url) unless current_user.admin?
    end
end