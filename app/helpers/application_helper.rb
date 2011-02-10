# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
	def sort_site_helper(text, param)
		key = param
		key += "_reverse" if params[:sort] == param
		key = "name_reverse" if params[:sort].nil?
		link_to_remote text,
			{:update => 'table', :before => "jQuery('#spinner-#{param}').show()", :success => "jQuery('#spinner-#{param}').hide()", :url => {:action => 'index', :params => params.merge({:sort => key, :page => nil})}},
			{:class => sort_th_class_helper(param), :title => "sort by this field", :href => url_for(:action => 'index', :params => params.merge({:sort => key, :page => nil}))}
	end
	
	def sort_th_class_helper(param)
		result = 'sort-asc' if params[:sort] == param
		result = 'sort-desc' if params[:sort] == param + '_reverse'
		return result
	end
end
