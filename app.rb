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
    bands = DB[:bands]
    status 200
    headers({ "Content-Type" =>"application/json" })
    [].tap do |json_response|
      bands.each do |band|
        json_response << { id: band[:id], name: band[:name], songs: songs_for_band(band) }
      end
    end.to_json
  end

  post '/bands' do
    band_name = params[:name]
    attributes = { name: band_name }
    bands = DB[:bands]
    band_id = bands.insert(attributes)

    status 201 # Created
    headers({ "Content-Type" =>"application/json" })
    attributes.merge(id: band_id, songs: []).to_json
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
    songs = DB[:songs]
    attributes = { title: params[:title], band_id: params[:band_id], rating: 0 }
    song_id = songs.insert(attributes)

    status 201
    headers({ "Content-Type" =>"application/json" })
    attributes.merge(id: song_id).to_json
  end

  put '/songs/:id' do
    songs = DB[:songs]
    songs.where(id: params[:id]).update(rating: params[:rating])
    attributes = songs.where(id: params[:id]).first

    status 200
    headers({ "Content-Type" =>"application/json" })
    attributes.to_json
  end

end
