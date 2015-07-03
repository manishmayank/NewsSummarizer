class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy]

  # GET /users
  # GET /users.json
  def index
    @users = User.all
  end

  # GET /users/1
  # GET /users/1.json
  def show
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
    
  end

  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  def update
    respond_to do |format|
      if @user.update(user_params)
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
    respond_to do |format|
      format.html { redirect_to users_url, notice: 'User was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def login
    params.each do |key, val|
      if val == ""
        render :json {
          success: false,
          reason: 0 # cannot send empty strings
        }
        return
      end
    end
    success = false
    if params[:username].present? && params[:password].present?
      success = true
      found_user = User.where(:username => params[:username]).first
      if found_user
        authorised_user = found_user.authenticate(params[:password])
      else
        success = false
      end
    end

    if authorised_user
      session[:user_id] = authorised_user.id
      session[:username] = authorised_user.username
    else
      success = false
    end

    if success
      bookmarks = getBookmarks(authorised_user.id)
      render :json {
        success: true
        bookmarks: bookmarks
      }
    else
      render :json {success: false}
    end
  end

  def signup
    success = true
    reason = 0    # all cool
    params.each do |key, val|
      if val == ""
        render :json {
          success: false,
          reason: 3    # empty strings
        }
        return
      end
    end
    if User.find_by_username(params[:username]).first
      success = false
      reason = 1    # username already taken
    elsif User.find_by_email(params[:email]).first
      success = false
      reason = 2   # email already registered

    end
    render :json {success: success, reason: reason}    
  end

  def logout
    session[:user_id] = nil
    session[:username] = nil
    render :json {success: true}
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_params
      params[:user]
    end
end
