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
	MetaSpotify::Track.search(params[:q])[:tracks].each do |track|
		name = track.name
		# album = track.album
		artists = []
		track.artists.each { |artist| artists.push artist.name }
		hash[name]  = artists
	end
	hash.to_json
end