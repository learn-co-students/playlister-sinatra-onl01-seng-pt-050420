require 'sinatra/base'
require 'sinatra'
# require 'sinatra/flash'

class SongsController < ApplicationController
    enable :sessions
    register Sinatra::Flash

    
    get '/songs' do
        @songs = Song.all
        erb :'/songs/index'
      end
    
      get '/songs/new' do
        erb :'/songs/new'
      end
    
      get '/songs/:slug' do
        @song = Song.find {|song| song.slug == params[:slug]}
        erb :'/songs/show'
      end
    
      post '/songs' do
        @song = Song.create(:name => params["Name"])
        @song.artist = Artist.find_or_create_by(:name => params["Artist Name"])
        @song.genre_ids = params[:genres]
        @song.save
        flash[:notice] = "Successfully created song."
        redirect "/songs/#{@song.slug}"
      end
    
      get '/songs/:slug/edit' do
        @song = Song.find {|song| song.slug == params[:slug]}
        erb :'/songs/edit'
      end
    
      patch '/songs/:slug' do
        @song = Song.find {|song| song.slug == params[:slug]}
        @song.name = params["Name"]
        @song.artist = Artist.find_or_create_by(:name => params["Artist Name"])
        
        @genres = Genre.find(params[:song][:genres])
        # binding.pry
        @song.song_genres.clear
        @genres.each do |genre|
          song_genre = SongGenre.new(:song => @song, :genre => genre)
          song_genre.save
        end
    
        @song.save
    
        
        flash[:notice] = "Successfully updated song."
        redirect "songs/#{@song.slug}"
    
      end
end
