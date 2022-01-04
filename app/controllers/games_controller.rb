require 'open-uri'
require 'json'

class GamesController < ApplicationController
  def new
    @grid_size = 10
    @letters = generate_grid(@grid_size)
    @letters_display = @letters.join(' ')
  end

  def generate_grid(grid_size)
    Array.new(grid_size) { ('A'..'Z').to_a.sample }
  end

  def score
    @attempt = params[:userinput]
    @compare_letters = params[:letters_display]
    @your_score = score_and_message(@attempt, @compare_letters)
    # @is_word = english_word?(@attempt)
    # @is_included = included?(@attempt, @letters)


  end

  def english_word?(word)
    response = URI.open("https://wagon-dictionary.herokuapp.com/#{word}")
    json = JSON.parse(response.read)
    json['found']
  end

  def included?(guess, letters)
    guess.chars.all? { |letter| guess.count(letter) <= letters.count(letter) }
  end
  # def compute_score(attempt, time_taken)
  #   time_taken > 60.0 ? 0 : attempt.size * (1.0 - (time_taken / 60.0))
  # end

  def score_and_message(attempt, grid)
    if included?(attempt.upcase, grid)
      if english_word?(attempt)
        "Congratulations! #{attempt} is a word!"
      else
        "Sorry! But #{attempt} is not a word!"
      end
    else
      "Sorry but #{attempt} does not exist in the grid. Try again!"
    end
  end
end

# def run_game(attempt, grid, start_time, end_time)
#   # TODO: runs the game and return detailed hash of result (with `:score`, `:message` and `:time` keys)
#   result = { time: end_time - start_time }

#   score_and_message = score_and_message(attempt, grid, result[:time])
#   result[:score] = score_and_message.first
#   result[:message] = score_and_message.last

#   result
# end

# def score_and_message(attempt, grid, time)
#   if included?(attempt.upcase, grid)
#     if english_word?(attempt)
#       score = compute_score(attempt, time)
#       @isword = [score, 'Congratulations!']
#     else
#       @notaword = [0, 'Sorry, not an English word.']
#     end
#   else
#     @[0, 'Not in the grid! Try again']
#   end
# end
# end
