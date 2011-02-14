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
		
		if !params[:query].nil?
			@sites.each {|site| site.name.gsub!("#{params[:query]}", "<span class=\"highlight\">#{params[:query]}</span>")}
		end
		
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
  
  # for advanced searches
  def advanced
  	# make the params hash a one dimensional hash
  	params[:search].each do |key, value|
  		params[key] = value
  	end
  	params.delete("search")
  
  	# validate all the input and report any errors if there are any
  	if params[:query].nil? #|| params[:query].length < 3
  		redirect_to_index("Your search query was invalid.  Query must be completed and >= 3 characters.")
  	else
  		params[:query] = params[:query].downcase.gsub(/<(.|\n)*?>/, "")
  	end
  	params[:realm] = valid_realm if !params[:realm].nil? && !params.empty? && format_input(params[:realm]) != "selectarealm"						# => realm
  	params[:region] = valid_region if !params[:region].nil? && !params.empty? && format_input(params[:region]) != "selectaregion"				# => region
  	params[:faction] = valid_faction if !params[:faction].nil? && !params.empty? && format_input(params[:faction]) != "selectafaction"	# => faction
  	
  	# now build the conditional based on parameters submitted
  	conditions = []
  	conditions[0] = "name LIKE ?"
  	conditions[1] = "%#{params[:query]}%"	# first add the search query
  	
  	# next add the realm if they requested one
  	if !params[:realm].nil? && format_input(params[:realm]) != "selectarealm"
  		if conditions.nil? || conditions.count == 0
  			conditions[0] = "realm LIKE ?"
  			conditions[1] = "%#{params[:realm]}%"
  		else
  			conditions[0] += " AND realm LIKE ?"
  			conditions[conditions.count] = "%#{params[:realm]}%"
  		end
  	end
  	
  	# then add a region, if requested
  	if !params[:region].nil? && format_input(params[:region]) != "selectaregion"
  		if conditions.nil? || conditions.count == 0
  			conditions[0] = "region LIKE ?"
  			conditions[1] = "%#{params[:region]}%"
  		else
  			conditions[0] += " AND region LIKE ?"
  			conditions[conditions.count] = "%#{params[:region]}%"
  		end
  	end
  	
  	# finally, a faction
  	if !params[:faction].nil? && format_input(params[:faction]) != "selectafaction"
  		if conditions.nil? || conditions.count == 0
  			conditions[0] = "faction LIKE ?"
  			conditions[1] = "%#{params[:faction]}%"
  		else
  			conditions[0] += " AND faction LIKE ?"
  			conditions[conditions.count] = "%#{params[:faction]}%"
  		end
  	end
 	
  	# now query SQL
  	@total = Site.count(:conditions => conditions)
  	@sites = Site.paginate :page => params[:page], :per_page => 25, :conditions => conditions, :order => 'name ASC'
  
  	# highlight the search string
  	@sites.each {|site| site.name.gsub!("#{params[:query]}", "<span class=\"highlight\">#{params[:query]}</span>")}
  end
 
private
	
	# format strings to make comparing/validating easier
	def format_input(text)
		text.downcase.gsub(' ', '').gsub('\\', '') 
	end
	
	# go back to the index action
	def redirect_to_index(msg = nil)
		flash[:notice] = msg if msg
		redirect_to :action => 'index'
	end

	# make sure the region is valid
	def valid_region
		!params[:region].nil? && !params[:region].empty? && (format_input(params[:region]) != 'selectaregion' || format_input(params[:region]) != 'sortbyregion') && %w[us eu].include?(format_input(params[:region])) ? format_input(params[:region]) : nil
	end
	
	# make sure the faction is valid
	def valid_faction
		# SCREW YOU HORDE! <3 Alliance <3
	!params[:faction].nil? && !params[:faction].empty? && (format_input(params[:faction]) != 'selectafaction' || format_input(params[:faction]) != 'sortbyfaction') && %w[alliance horde].include?(format_input(params[:faction])) ? format_input(params[:faction]) : nil
	end
	
	# make sure the realm is valid
	def valid_realm
		realms = get_realms
		params[:realm] = 'bleedinghollow' if realms.count == 0 # just in case
		!params[:realm].nil? && !params[:realm].empty? && (format_input(params[:realm]) != 'selectarealm' || format_input(params[:realm]) != 'sortbyrealm') && realms.include?(params[:realm].downcase.gsub('\\', '').gsub(' ', '')) ? format_input(params[:realm]) : nil 
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
