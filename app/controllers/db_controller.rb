class DbController < ApplicationController
	def index
		page = params[:page] || 1
		@sites = Site.paginate :page => page, :order => 'name ASC'
	end
	
	def save
		@site = Site.new(params[:site])
		@site.count = 0
		if @site.save
			redirect_to_index("Your site has been added.")
		else
			flash[:notice] = 'Failed to add site to the database.'
			render :action => 'add'
		end
	end
	
	def out
		site = Site.find(params[:id])
		site.count += 1
		if site.save
			redirect_to "#{site.uri}"
		else
			redirect_to_index('Failed to update count')
		end
	end
	
private
	def redirect_to_index(msg = nil)
		flash[:notice] = msg if msg
		redirect_to :action => 'index'
	end

protected
	def authorize
	end
end
