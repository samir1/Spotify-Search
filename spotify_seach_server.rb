require 'sinatra'
require 'sinatra/cross_origin'
require 'json'
require 'meta-spotify'


# cross orgin fix
set :allow_origin, :any
set :allow_methods, [:get, :post, :options]
set :allow_credentials, true
set :max_age, "1728000"
set :expose_headers, ['Content-Type']

configure do
  enable :cross_origin
end


# search spotify
get '/' do
	content_type :json
	hash = {}
	num = 0
	MetaSpotify::Track.search(params[:q])[:tracks].each_with_index do |track, index|
		name = track.name
		artists = ""
		track.artists.each_with_index do |artist, artist_index|
			if artist_index == 0
				artists += artist.name
			else
				artists += ", " + artist.name
			end
		end
		uri = track.uri
		link = "http://open." + uri.split(":")[0] + ".com/" + uri.split(":")[1] + "/" + uri.split(":")[2]
		hash[index] = "<a href=\"" + link + "\" target=\"_blank\">" + name + " by " + artists + "</a><br />"
	end
	hash.to_json
end