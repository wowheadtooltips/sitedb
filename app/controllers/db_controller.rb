class DbController < ApplicationController
	
	# the default list/action
	def index	
		# for column sorting
		sort = case params[:sort]
			when 'name' then 'name ASC'
			when 'region' then 'region ASC'
			when 'realm' then 'realm ASC'
			when 'faction' then 'faction ASC'
			when 'count' then 'count ASC'
			when 'name_reverse' then 'name DESC'
			when 'region_reverse' then 'region DESC'
			when 'realm_reverse' then 'realm DESC'
			when 'faction_reverse' then 'faction DESC'
			when 'count_reverse' then 'count DESC'
		end
		
		# for when the page is first loaded
		sort = 'name ASC' if params[:sort].nil?
		params[:page] = 1 if params[:page].nil?
		
		# see how they want to filter
		if params[:filter].nil?
			# for searches
			conditions = ["name LIKE ?", "%#{params[:query]}%"] unless params[:query].nil?
		else
			# filter by first character
			if params[:filter] == 'reset'
				conditions = ''
			else
				conditions = ["name LIKE ?", "#{params[:filter]}%"]
			end
		end

		# pull the sites from the database
		@total = Site.count(:conditions => conditions)
		@sites = Site.paginate :page => params[:page], :per_page => 25, :conditions => conditions, :order => sort
		
		# use ajax to update the site list
		if request.xml_http_request?
			render :partial => "sites_list", :layout => false
		else
			respond_to do |format|
				format.html
				format.xml { render :layout => false, :xml => @sites.to_xml() }
			end
		end
	end
	
	# save the new site
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
	
	# add one to the count and redirect to the uri
	def out
		site = Site.find(params[:id])
		site.count += 1
		if site.save
			redirect_to "#{site.uri}"
		else
			redirect_to_index('Failed to update count')
		end
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

protected
	# to prevent the filter from requiring login
	def authorize
	end
end
