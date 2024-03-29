class UsersController < ApplicationController
	before_filter :signed_in_user, only: [:index,:edit, :update, :destroy]
	before_filter :correct_user, only: [:edit, :update]
	before_filter :admin_user, only: :destroy
	before_filter :unsigned_in_user, only: [:new,:create]

	def show
		@user = User.find(params[:id])
		@microposts = @user.microposts.paginate(page: params[:page])
	end

	def new
		@user = User.new
	end

	def index
		@users = User.paginate(page: params[:page])
	end
	
	def create
		@user = User.new(params[:user])
		if @user.save
			sign_in @user
			flash[:success] = "Welcome to the Sample App!"
			redirect_to @user
		else
			render 'new'
		end
	end

	def edit
	end

	def update
		if @user.update_attributes(params[:user])
			flash[:success] = "Profile updated"
			sign_in @user
			redirect_to @user
		else
			render 'edit'
		end
	end

	def destroy
		@userToDestroy = User.find(params[:id])

		if current_user?(@userToDestroy)
			redirect_to root_path , notice: "You cannot delete your own account."
		else

			@userToDestroy.destroy
			flash[:success] = "User destroyed."
			redirect_to users_path
		end 
	end

	private


	def unsigned_in_user
		if signed_in?
			redirect_to(root_path)		
		end
	end



	def correct_user
		@user = User.find(params[:id])
		redirect_to(root_path) unless current_user?(@user)
	end



	def admin_user
		redirect_to(root_path) unless current_user.admin?
	end
end
