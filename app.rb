# Set up for the application and database. DO NOT CHANGE. ###################
require "sinatra"                                                           #
require "sinatra/reloader" if development?                                  #
require "sequel"                                                            #
require "logger"                                                            #
require "twilio-ruby"                                                       #
DB ||= Sequel.connect "sqlite://#{Dir.pwd}/development.sqlite3"             #
DB.loggers << Logger.new($stdout) unless DB.loggers.size > 0                #
def view(template); erb template.to_sym; end                                #
use Rack::Session::Cookie, key: 'rack.session', path: '/', secret: 'secret' #
before { puts "Parameters: #{params}" }                                     #
after { puts; }                                                             #
#############################################################################

events_table = DB.from(:events) #creates variable called events_table
rsvps_table = DB.from(:rsvps) #creates variable called rsvps_table

get "/" do
    puts events_table.all
    @events = events_table.all #creates an array of hashes that represents the events table
    view "events"
end

get "/events/:id" do #creates events detail page route : makes it a placeholder for id
    @event = events_table.where(id: params[:id]).first #creates a hash from events_table for a single event
    view "event"
end

get "/events/:id/rsvps/new" do #creates a form for the event identified by id to input an rsvp
    @event = events_table.where(id: params[:id]).first #creates a hash from events_table for a single event
    view "new_rsvp"
end