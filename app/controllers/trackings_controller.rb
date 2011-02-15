# handles redirection tracking
class TrackingsController < ApplicationController

	# default action
  def index
  	# set the default page
  	params[:page] = 1 if params[:page].nil?
  	
  	# get the count, and the sites
		@total = Site.count(:all)
		@sites = Site.paginate :page => params[:page], :per_page => 50, :order => "name ASC"
		
		# get the number of tracked visitors for each site
		@sites.each {|site| site[:visitors] = Tracking.count(:conditions => ["siteid = ?", site.id])}
  end
  
  # view tracking details for an ID
  def details
  	params[:id] = 1 if params[:id].nil?
  	params[:page] = 1 if params[:page].nil?
  	@total = Tracking.count(:conditions => ["siteid = ?", params[:id]])
  	@trackings = Tracking.paginate :page => params[:page], :per_page => 25, :conditions => ["siteid = ?", params[:id]], :order => "visited DESC"
  end
end
