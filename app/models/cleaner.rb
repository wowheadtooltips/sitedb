module Cleaner
	def self.append_features(base)
		base.before_save do |model|
			model.name = model.name.gsub(/<(.|\n)*?>/, "") if model.respond_to?(:name)
			model.uri = model.uri.gsub(/<(.|\n)*?>/, "") if model.respond_to?(:uri)
			model.region = model.region.gsub(/<(.|\n)*?>/, "") if model.respond_to?(:region)
			model.realm = model.realm.gsub(/<(.|\n)*?>/, "") if model.respond_to?(:realm)
			model.faction = model.faction.gsub(/<(.|\n)*?>/, "") if model.respond_to?(:faction)
		end
	end
end