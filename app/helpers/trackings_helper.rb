module TrackingsHelper
	def format_date(date)
		date.to_time.strftime("%Y/%m/%d %H:%M:%S%p").downcase
	end
end
