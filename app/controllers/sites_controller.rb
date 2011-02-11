class SitesController < ApplicationController
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

  # GET /sites/1/edit
  def edit
    @site = Site.find(params[:id])
  end

  # PUT /sites/1
  # PUT /sites/1.xml
  def update
    @site = Site.find(params[:id])

    respond_to do |format|
      if @site.update_attributes(params[:site])
        format.html { redirect_to(@site, :notice => 'Site was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @site.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /sites/1
  # DELETE /sites/1.xml
  def destroy
    @site = Site.find(params[:id])
    @site.destroy

    respond_to do |format|
      format.html { redirect_to(sites_url) }
      format.xml  { head :ok }
    end
  end
end
