class AddTestData < ActiveRecord::Migration
  def self.up
	Site.delete_all
	Site.create(:uri => 'http://wowhead-tooltips.com', :name => 'Wowhead Tooltips', :region => 'US', :realm => 'Bleeding Hollow', :faction => 'Alliance', :count => 0)
  end

  def self.down
  	Site.delete_all
  end
end
 