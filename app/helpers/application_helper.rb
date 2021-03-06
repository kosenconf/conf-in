# coding: utf-8
require 'rubygems'
require 'net/http'
require 'uri'
require 'nokogiri'
require 'open-uri'

module ApplicationHelper
  SIZE = {
      mini: {size:'24x24', def_url: "images/24.png"},
      normal: {size: '48x48', def_url: "images/48.png"},
      bigger: {size: '73x73', def_url: "images/73.png"},
      default: {size:'', def_url: ''}
  }

  # ページタイトルの連結
	def title
		if @page_title.nil? then
			"カンファイン"
		else
			"#{@page_title} | カンファイン"
		end
	end

  # QRコードのURL生成
  def url_for_qr(str)
    "https://chart.googleapis.com/chart?chs=500x500&cht=qr&chl=#{CGI.escape(str)}"
  end

	# QRコードの生成
	def qrimg_tag(str, options={width: 150})
	  image_tag url_for_qr(str), options
	end

	# GIFのQRコードのバイナリを返す
	def qr_gif_binary(qr_str)
    qr_url = "http://chart.googleapis.com/chart?chof=gif&chs=500x500&cht=qr&chl=#{CGI.escape(qr_str)}"

	  blob = Net::HTTP.get_response(URI.parse(qr_url)).body

    return blob
	end

	# TwiconのURL
  def twicon_url(user, size = :normal)
    unless user.tw_id.blank?
      unless user.twicon_url.blank?
        # tw_idとtwicon_urlが空じゃなければそのまま返する
        twicon_url_with_size(user.twicon_url, size)
      else
        # twicon_urlが無ければAPIに任せる
        icon_user_url(user, size: size)
      end
    else
      # tw_idが無ければデフォルトアイコンを表示
      root_url + SIZE[size][:def_url]
    end
  end
  
  # Twicon の画像タグ
  def twicon_tag(user, size = :normal)
    image_tag twicon_url(user, size), alt: user.name, size: SIZE[size][:size]
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
  

  # TwiconURLを生で取得
  def get_raw_url(id)
    begin
      api = "https://api.twitter.com/1/users/profile_image/#{id}"

      url = URI.parse api
      res = url.open
      
      twicon = res.base_uri.to_s

    rescue => e
      nil
    end
  end

  # 名前と拡張子に分ける
  def split_ext(str)
    str.split(/\.(jpg|jpeg|jpe|png|gif|bmp|)$/i)
  end

  # 生からオリジナルサイズのURLに変換
  def original(url)
    split_url = split_ext(url)
    orig_name = split_url[0].gsub(/_normal$/, '')

    if split_url[1]
      [orig_name, split_url[1]].join('.')
    else
      orig_name
    end
  end

  # オリジナルURLからサイズ入りURLに変換
  def twicon_url_with_size(url, size = :bigger)
    # 名前と拡張子に分ける
    spl = split_ext(url)

    # 名前とサイズでつなげる
    ret = size ? [spl[0], size].join('_') : spl[0]

    if spl.count == 1
      # 拡張子無し
      ret
    elsif spl.count == 2
      # 拡張子をつなげる
      [ret, spl[1]].join('.')
    end
  end
end
