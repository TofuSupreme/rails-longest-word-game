require 'open-uri'
require 'json'

class GamesController < ApplicationController
  def new
    @grid_size = 10
    @letters = generate_grid(@grid_size)
    @separated = @letters.join('')
  end

  def generate_grid(grid_size)
    Array.new(grid_size) { ('A'..'Z').to_a.sample }
  end

  def score
    @user_guess = params[:userinput]
    @letters_display = params[:separated]
    @user_results = score_and_message(@user_guess, @letters_display)
    @score_tracking = score_tracker(score)
  end

  def english_word?(word)
    response = URI.open("https://wagon-dictionary.herokuapp.com/#{word}")
    json = JSON.parse(response.read)
    json['found']
  end

  def included?(guess, letters)
    guess.chars.all? { |letter| guess.upcase.count(letter) <= letters.count(letter) }
  end

  def score_and_message(attempt, grid)
    if included?(attempt.upcase, grid)
      if english_word?(attempt)
        "Congratulations! #{attempt} is a word!"
        score_tracker(score)
      else
        "Sorry! But #{attempt} is not a word!"
      end
    else
      "Sorry but #{attempt} does not exist in the grid. Try again!"
    end
  end

  def score_tracker(score)
    score = 0
    score += 1
  end
end
