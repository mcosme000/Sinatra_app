require 'sinatra'
require 'sinatra/reloader' if development?
require 'pry-byebug'
require 'better_errors'
require 'sqlite3'

configure :development do
  use BetterErrors::Middleware
  BetterErrors.application_root = File.expand_path(__dir__)
end

DB = SQLite3::Database.new(File.join(File.dirname(__FILE__), 'db/jukebox.sqlite'))

get '/' do
  # @artists = DB.execute('SELECT artists.name, albums.title FROM artists
  #   JOIN albums ON artists.id = albums.artist_id
  #   WHERE albums.artist_id IN (SELECT albums.artist_id FROM albums
  #                             GROUP BY albums.artist_id)')
  @artists = DB.execute('SELECT name FROM artists').sample(5).flatten
  erb :index
end

get '/artists_list/' do
  # TODO: Gather all artists to be displayed on home page
  @artists = DB.execute('SELECT * FROM artists')
  erb :artists_list
end

get '/artists/:id' do
  id = params[:id]
  @artist = DB.execute('SELECT name FROM artists WHERE id = ?', id).flatten.first
  @albums = DB.execute('SELECT albums.title, albums.id FROM albums
    JOIN artists ON artists.id = albums.artist_id
    WHERE artists.id = ?', id)
  erb :artists
end

get '/albums/:id' do
  id = params[:id]
  @artist = DB.execute('SELECT artists.id, artists.name FROM artists
    JOIN albums ON artists.id = albums.artist_id
    WHERE albums.id = ?', id).flatten
  @album = DB.execute('SELECT title FROM albums WHERE id = ?', id).flatten.first
  @tracks = DB.execute('SElECT tracks.name FROM tracks
    JOIN albums ON albums.id = tracks.album_id
    WHERE albums.id = ?', id).flatten
  erb :albums
end

# get '/tracks/:id' do
#   id = params[:id]
# end
