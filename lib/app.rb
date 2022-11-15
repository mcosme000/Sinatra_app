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
  # "Hello from my Sinatra app!"
  # TODO: Gather all artists to be displayed on home page
  # @artists = DB.execute("SELECT * FROM artists")
  # erb :home # Will render views/home.erb file (embedded in layout.erb)
  @artists = DB.execute('SELECT * FROM artists').sample(5)
  erb :index
end

get '/artists/' do
  # TODO: Gather all artists to be displayed on home page
  @artists = DB.execute('SELECT name FROM artists').flatten
  erb :artists_list
end
