class AdminController < ApplicationController
	def login
		session[:user_id] = nil
		if request.post?
			user = User.authenticate(params[:name], params[:password])
			if user
				uri = session[:uri]
				session[:uri] = nil
				session[:user_id] = user.id
				redirect_to(uri || {:controller => 'sites', :action => 'index'})
			else
				flash.now[:notice] = "Invalid user/password combination."
			end
		end
	end
	
	def logout
		session[:user_id] = nil
		flash[:notice] = "You have been logged out"
		redirect_to(:action => 'login')
	end
	
	def index
	end

end
