require 'sinatra'
require 'json'
require 'faraday'
require 'haml'

class CabinPorn < Sinatra::Base

  get '/api/photos/?:offset?' do
    content_type :json
    offset = params['offset'] || 0
    conn = Faraday.new(:url => 'http://api.tumblr.com/v2/blog/freecabinporn.com') do |faraday|
    	faraday.request  :url_encoded             # form-encode POST params
    	faraday.adapter  Faraday.default_adapter  # make requests with Net::HTTP
    end
    resp = conn.get 'posts/photo', {'api_key' => 'WPJuMucCJ6ZqdXrhZo9fKkEwP8SYYsKPWcQn7gTWZ79VPanKYd', 'offset' => offset}
    posts = JSON.parse(resp.body)
    posts['response']['posts'].collect do |post|
    	{photo_url: post['photos'].first['original_size']['url'] }
    end.to_json
    #{'test' => 'world'}.to_json
  end

  get '/photos' do
    haml :photos
  end

end