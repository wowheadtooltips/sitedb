class Site < ActiveRecord::Base

	ACCEPT_FACTION = [
		['Alliance',	'Alliance'],
		['Horde',		'Horde']
	]
	
	ACCEPT_REGION = [
		['US',	'US'],
		['EU',	'EU']
	]

	cattr_reader :per_page
	@@per_page = 25

	validates_presence_of :uri, :name, :realm, :region, :faction
	validates_uniqueness_of :uri, :name
	validates_format_of :uri, :with => URI::regexp(%w(http https))
	validates_inclusion_of :faction, :in => ACCEPT_FACTION.map {|disp, value| value}
	validates_inclusion_of :region, :in => ACCEPT_REGION.map {|disp, value| value}
		
	def self.first_letter(letter)
		@sites = self.find(:all, :conditions => ['LOWER (name) LIKE ?', "#{letter.downcase}%"], :order => 'name ASC')
		@sites.count
	end
end
