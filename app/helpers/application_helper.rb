module ApplicationHelper
  SIZE = {
      mini: 'mini',
      normal: 'normal',
      bigger: 'bigger',
      default: ''
  }

  # ページタイトルの連結
	def title
		if @page_title.nil? then
			$SYSTEM_TITLE
		else
			"#{@page_title} | #{$SYSTEM_TITLE}"
		end
	end

  # QRコードのURL生成
  def url_for_qr(str)
    "http://chart.apis.google.com/chart?chs=150x150&cht=qr&chl=#{CGI.escape(str)}"
  end

	# QRコードの生成
	def qrimg_tag(str)
	  image_tag url_for_qr(str)
	end

	# Twitterアイコンの表示
	def twicon_tag(id, size=:default)
	  unless id.blank?
	   image_tag "http://api.dan.co.jp/twicon/#{id}/#{SIZE[size]}"
	  else
	    image_tag( size == :bigger ? "73.png" : "24.png" )
	  end
	end
end
