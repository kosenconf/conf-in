# coding: utf-8
require 'rubygems'
require 'RMagick'
require 'net/http'

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
	  image_tag url_for_qr(str), width: 150
	end

	# JPGに変換したQRコードのバイナリを返す
	def qr_jpg_binary(qr_str)
	  qr_url = url_for_qr(qr_str)

	  blob = Net::HTTP.get_response(URI.parse(qr_url)).body
    img = Magick::ImageList.new
    img.from_blob(blob)
    img.format = "JPG"

    return img.to_blob
	end

	# Twitterアイコンの表示
	def twicon_image(id, size = :default)
=begin
    unless id.blank?
      "http://twicon.yayugu.net/#{id}/#{SIZE[size]}"
    else
	    size == :bigger ? "#{root_url}/images/73.png" : "#{root_url}/images/24.png"
    end
=end
	  size == :bigger ? "#{root_url}/images/73.png" : "#{root_url}/images/24.png"
	end
  
	# Twitterアイコンの表示
	def twicon_tag(id, size = :default)
=begin
    unless id.blank?
	    link_to(
        image_tag("http://twicon.yayugu.net/#{id}/#{SIZE[size]}",
                  size: (size == :bigger ? '73x73' : '24x24'),
                  alt: id
        ),
        "http://twitter.com/#{id}"
      )
	  else
	    image_tag( size == :bigger ? "73.png" : "24.png" )
	  end
=end
	  image_tag( size == :bigger ? "73.png" : "24.png" )
	end
	
  # ネストしたフィールドを動的に削除
  def link_to_remove_fields(name, f, html_options={})
    f.hidden_field(:_destroy) + link_to_function(name, "remove_fields(this)", html_options)
  end
  
  # ネストしたフィールドを動的に追加
  def link_to_add_fields(name, f, association, html_options={})
    new_object = f.object.class.reflect_on_association(association).klass.new
    fields = f.fields_for(association, new_object, :child_index => "new_#{association}") do |builder|
      render(association.to_s.singularize + "_fields", :f => builder)
    end
    link_to_function(name, "add_fields(this, '#{association}', '#{escape_javascript(fields)}')",html_options)
  end

	# htmlエスケープ後に改行コードを<br>に変換する
	def hbr(str)
		str = html_escape(str)
		raw str.gsub(/\r\n|\r|\n/, "<br />")
	end
end
