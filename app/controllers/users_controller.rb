class UsersController < ApplicationController
  before_action :set_user, only: %i[ show edit update destroy ]

  # GET /users or /users.json
  def index
    if params[:search]
      @users = User.where("CONCAT(name->>'title', ' ', name->>'first', ' ', name->>'last') ILIKE ?", "%#{params[:search]}%").order(:email).page(params[:page])
    else
      @users = User.order(:email).page(params[:page])
    end
  end

  # GET /users/1 or /users/1.json
  def show
  end

  # GET /users/new
  def new
    @user = User.new
  end

  # GET /users/1/edit
  def edit
  end

  # POST /users or /users.json
  def create
    params = user_params
    @user = User.new(user_data(params))
    @user.avatar.attach(params[:avatar])

    respond_to do |format|
      if @user.save && @user.avatar.attached?
        format.html { redirect_to user_url(@user), notice: "User was successfully created." }
        format.json { render :show, status: :created, location: @user }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /users/1 or /users/1.json
  def update
    respond_to do |format|
      params = user_params

      @user.avatar.attach(params[:avatar])

      if @user.update(user_data(params)) && @user.avatar.attached?
        format.html { redirect_to user_url(@user), notice: "User was successfully updated." }
        format.json { render :show, status: :ok, location: @user }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1 or /users/1.json
  def destroy
    @user.destroy

    respond_to do |format|
      format.html { redirect_to users_url, notice: "User was successfully deleted." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def user_params
      params.require(:user).permit(
        :gender,
        :email,
        :naturalization,
        :avatar,
        :title,
        :first_name,
        :last_name
      )
    end

    def user_data(params)
      {
        name: {
          "title": params[:title],
          "first": params[:first_name],
          "last": params[:last_name],
        },
        email: params[:email],
        gender: params[:gender],
        naturalization: params[:naturalization],
      }
    end
end
