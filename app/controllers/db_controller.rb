class DbController < ApplicationController
	
	helper_method :sort_column, :sort_direction
	
	def index
		page = params[:page] || 1
		@sites = Site.paginate :page => page, :order => "#{sort_column} #{sort_direction}"
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
	
	def sort
		page = params[:page] || 1
		@sites = Site.paginate(:page => page, :conditions => ['LOWER (name) LIKE ?', "#{params[:id].downcase}%"], :order => "#{sort_column} #{sort_direction}")
	end
	
	def search
		page = params[:page] || 1
		@sites = Site.paginate(:page => page, :conditions => ['LOWER (name) LIKE ?', "%#{params[:search].downcase}%"], :order => "#{sort_column} #{sort_direction}")
	end
	
	def gohome
		redirect_to 'http://wowhead-tooltips.com'
	end
	
	def forums
		redirect_to 'http://support.wowhead-tooltips.com'
	end
	
	def wiki
		redirect_to 'http://wiki.wowhead-tooltips.com'
	end
	
private
	def redirect_to_index(msg = nil)
		flash[:notice] = msg if msg
		redirect_to :action => 'index'
	end
	
	def sort_column
		%w[name region realm faction count].include?(params[:sort]) ? params[:sort] : 'name'
	end
	
	def sort_direction
		%w[asc desc].include?(params[:direction]) ? params[:direction] : 'asc'
	end

protected
	def authorize
	end
end
