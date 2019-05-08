class UsersController < ApplicationController
  before_action :find_user, except: %i[index new create]

  def index
    @users = User.all
  end

  def show; end

  def new
    @user = User.new
  end

  def edit; end

  def create
    @user = User.new(user_params)
    if @user.save
      flash[:positive] = "Welcome, #{@user.first_name}. Have a good time here. 😀"
      log_in @user
      redirect_to @user
    else
      flash[:negative] = 'Something went wrong'
      render 'new'
    end
  end

  def update
    if @user.update_attributes(user_params)
      flash[:positive] = 'Your details were successfully updated.'
      redirect_to @user
    else
      flash[:negative] = 'Something went wrong'
      render 'edit'
    end
  end

  def destroy
    if @user.destroy
      flash[:positive] = 'Sorry to see you go.'
      redirect_to @users_path
    else
      flash[:negative] = 'Something went wrong'
      redirect_to @users_path
    end
  end

  private

  def find_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:first_name, :last_name, :email, :password, :password_confirmation)
  end
end
