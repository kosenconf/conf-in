module ApplicationHelper
	def title
		if @page_title.nil? then
			$SYSTEM_TITLE
		else
			"#{@page_title} | #{$SYSTEM_TITLE}"
		end
	end
end
