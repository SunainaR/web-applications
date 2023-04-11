# file: app.rb
require 'sinatra'
require "sinatra/reloader"
require_relative 'lib/database_connection'
require_relative 'lib/album_repository'
require_relative 'lib/artist_repository'

DatabaseConnection.connect

class Application < Sinatra::Base
  configure :development do
    register Sinatra::Reloader
    also_reload 'lib/album_repository'
    also_reload 'lib/artist_repository'
  end

  # get '/albums' do
  #   repo = AlbumRepository.new
  #   albums = repo.all
  #   albums.map do |album|
  #     album.title 
  #   end.join(", ")
  # end
    get '/albums' do
      repo = AlbumRepository.new
      @albums = repo.all

      return erb(:albums)
    end

  post '/albums' do
    album = Album.new
    album.title = params[:title]
    album.release_year = params[:release_year]
    album.artist_id = params[:artist_id]
    repo = AlbumRepository.new
    repo.create(album)
    return ''
  end

  get '/albums/:id' do
    repo = AlbumRepository.new
    @album = repo.find(params[:id])

    repo = ArtistRepository.new
    @artist = repo.find(@album.artist_id)

    return erb(:album)

  end

  get '/artists' do
    repo = ArtistRepository.new
    @artists = repo.all
    return erb(:artists)
  end

  post '/artists' do

    if invalid_artist_request_parameters?
      # Set the response code
      # to 400 (Bad Request) - indicating
      # to the client it sent incorrect data
      # in the request.
      status 400
  
      return ''
    end

    artist = Artist.new
    artist.name = params[:name]
    artist.genre = params[:genre]
    repo = ArtistRepository.new
    repo.create(artist)
    return 'New artist added'
  end

  get '/artists/new' do

    erb(:new_artist)

  end

  get '/artists/:id' do
    artists = ArtistRepository.new
    @artist = artists.find(params[:id])
    return erb(:artist)
  end

  private
  def invalid_artist_request_parameters?
    return true if params[:name] == nil || params[:genre] == nil

    # Are they empty strings?
    return true if params[:name] == "" || params[:genre] == ""

    return false
  end
end