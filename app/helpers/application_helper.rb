module ApplicationHelper
	def title
		if @page_title.nil? then
			$SYSTEM_TITLE
		else
			"#{@page_title} | #{$SYSTEM_TITLE}"
		end
	end
	
	def qrimg_tag(str)
	  image_tag "http://chart.apis.google.com/chart?chs=150x150&cht=qr&chl=#{CGI.escape(str)}"
	end
end
