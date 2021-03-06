class AdminController < ApplicationController
	
  before_filter :confirm_admin, :except=>[:help]

	def index
	end


  def new
    	@user = User.new
  end

  def show
  end

  def help
  end

  #create new system user
	def create
    @user = User.new(params[:user].permit(:username, :role, :password, :password_confirmation))
      if @user.save #save the user
        flash[:notice1] = "New user created"
        redirect_to new_admin_path
      else          
        @user.errors.full_messages.each do |message_error|   
          flash[:notice2] = message_error
          redirect_to :controller=>"admin", :action=>"new" 
          return false 
        end

      end
  end



end
