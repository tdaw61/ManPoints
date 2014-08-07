class UsersController < ApplicationController
  before_action :set_user, only: [:show, :destroy]
  before_action :signed_in_user, only: [:edit, :index, :update]
  before_action :correct_user, only: [:edit, :update]
  before_action :admin_user,     only: :destroy


  # GET /users
  # GET /users.json
  def index
    if current_user.super_user?
      @users = User.paginate(page: params[:page])
    else
      render '/public/404'
    end
  end

  def home
    if signed_in?
      @userpost  = current_user.userposts.build
      @feed_items = current_user.userposts.paginate(page: params[:page])
      @scores = current_user.scores
    end
  end

  # GET /users/1
  # GET /users/1.json
  def show
    @userposts = @user.userposts.paginate(page: params[:page])
    @games = @user.games
  end

  # GET /users/new
  def new
    @user = User.new
  end

  # GET /users/1/edit
  def edit
  end

  # POST /users
  # POST /users.json
  def create
    @user = User.new(user_params)

    respond_to do |format|
      if @user.save
        sign_in @user
        format.html { redirect_to @user, notice: 'User was successfully created.' }
        format.json { render :show, status: :created, location: @user }
      else
        format.html { render :new }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  def update



    respond_to do |format|
      if @user.update_attributes(user_params)
        flash[:success] = "Profile updated"
        format.html { redirect_to @user, notice: 'User was successfully updated.' }
        format.json { render :show, status: :ok, location: @user }
      else
        format.html { render :edit }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end


  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    @user.destroy
    flash[:success] = "User deleted."
    respond_to do |format|
      format.html { redirect_to users_url}
      format.json { head :no_content }
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_user
    @user = User.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end


  def correct_user
    @user = User.find(params[:id])
    redirect_to(root_url) unless current_user?(@user)
  end

  def admin_user
    redirect_to(root_url) unless current_user.admin?
  end
end