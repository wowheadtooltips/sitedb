# handles advanced search options
class SearchController < ApplicationController
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
				conditions = nil
			else
				conditions = ["name LIKE ?", "#{params[:filter]}%"]
			end
		end

		# see if they want to sort by realm
		conditions = ["realm LIKE ?", "%#{valid_realm}%"] if !params[:realm].nil? && params[:realm].downcase.gsub(' ', '') != 'sortbyrealm'
		# or perhaps region?
		conditions = ["region LIKE ?", "%#{valid_region}%"] if !params[:region].nil? && params[:region].downcase.gsub(' ', '') != 'sortbyregion'
		# or maybe faction?
		conditions = ["faction LIKE ?", "%#{valid_faction}%"] if !params[:faction].nil? && params[:faction].downcase.gsub(' ', '') != 'sortbyfaction'

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
 
private

	# make sure the region is valid
	def valid_region
		%w[US EU].include?(params[:region]) ? params[:region] : 'US'
	end
	
	# make sure the faction is valid
	def valid_faction
		# SCREW YOU HORDE!
		%w[Alliance Horde].include?(params[:faction]) ? params[:faction] : 'Alliance'
	end
	
	# make sure the realm is valid
	def valid_realm
		realms = get_realms
		params[:realm] = 'Bleeding Hollow' if realms.count == 0 # just in case
		realms.include?(params[:realm].downcase.gsub('\\', '').gsub(' ', '')) ? params[:realm] : 'Bleeding Hollow' 
	end

	# get realms from mysql
	def get_realms
		sites = Site.find(:all)
		realms = []
		x = 0
		sites.each do |site|
			if !realms.nil? && !realms.include?(site.realm.downcase.gsub('\\', '').gsub(' ', ''))
				realms[x] = site.realm.downcase.gsub('\\', '').gsub(' ', '')
				x += 1
			end
		end
		realms.compact.sort
		realms.reject(&:blank?)
	end
end
