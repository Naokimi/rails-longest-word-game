require 'open-uri'
require 'json'

class GamesController < ApplicationController
  def new
    grid_size = 10
    @letters = []
    @letters << ('A'..'Z').to_a.sample until @letters.length == grid_size
  end

  def score
    attempt_array = params[:answer].upcase.chars
    params[:letters].split(' ').each { |letter| attempt_array.delete_at(attempt_array.index(letter)) if attempt_array.index(letter) }

    if JSON.parse(open("https://wagon-dictionary.herokuapp.com/#{params[:answer]}").string)['found'] == false
      @answer = "Sorry, but #{params[:answer].upcase} is not a valid English word..."
    elsif attempt_array.empty? == false
      @answer = "Sorry, but #{params[:answer].upcase} can't be built out of #{params[:letters].split(' ').join(',')}"
    else
      session[:score] = 0 if session[:score].nil?
      session[:score] += params[:answer].length
      @answer = "Congratulations! #{params[:answer].upcase} is a valid English word!"
      @current_score = "This round's score: #{params[:answer].length} points."
      @total_score = "Total score: #{session[:score]} points."
    end
  end
end
