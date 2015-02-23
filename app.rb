require 'sinatra'
require 'sequel'
require './config/initializer'
require 'json'
require 'rack/cors'

class RockAndRollAPI < Sinatra::Base

  use Rack::Cors do
    allow do
      origins  '*'
      resource '*', headers: :any, methods: %i[get post put options]
    end
  end

  def json_params
    JSON.parse(request.body.read)
  end

  def songs_for_band(band)
    band_songs_records = DB[:songs].where(band_id: band[:id])
    band_songs_records.map do |song|
      { id: song[:id], title: song[:title], rating: song[:rating] }
    end
  end

  get '/' do
    [200, { "Content-Type" =>"application/json" }, { name: "Rock & Roll API", version: '0.1' }.to_json]
  end

  get '/bands' do
    status 200
    headers({ "Content-Type" =>"application/json" })

    songs_payload = []
    bands_payload = DB[:bands].map do |band|
      band_songs = songs_for_band(band)
      songs_payload.concat band_songs
      { id: band[:id], name: band[:name], songs: band_songs.map {|s| s[:id]} }
    end

    {
      bands: bands_payload,
      songs: songs_payload
    }.to_json
  end

  post '/bands' do
    attributes = json_params['band']
    band_id = DB[:bands].insert(attributes)

    status 201 # Created
    headers({ "Content-Type" =>"application/json" })

    {
      band: attributes.merge(id: band_id, songs: [])
    }.to_json
  end

  get '/bands/:id' do
    band = DB[:bands].where(id: params[:id]).first

    status 200
    headers({ "Content-Type" =>"application/json" })
    {
      id: band[:id],
      name: band[:name],
      songs: songs_for_band(band)
    }.to_json
  end

  get '/bands/:id/songs' do
    band = DB[:bands].where(id: params[:id]).first

    status 200
    headers({ "Content-Type" =>"application/json" })
    songs_for_band(band).to_json
  end

  post '/songs' do
    attributes = json_params['song'].merge 'rating' => 0
    attributes['band_id'] = attributes.delete('band')
    song_id = DB[:songs].insert(attributes)

    status 201
    headers({ "Content-Type" =>"application/json" })

    {
      song: attributes.merge(id: song_id)
    }.to_json
  end

  put '/songs/:id' do
    songs = DB[:songs]
    new_rating = json_params['song']['rating']
    songs.where(id: params[:id]).update(rating: new_rating)
    attributes = songs.where(id: params[:id]).first

    status 200
    headers({ "Content-Type" =>"application/json" })

    {
      song: attributes
    }.to_json
  end

end
