require 'codebreaker'
require 'yaml'
require_relative 'database'

class WebGame
  UNPROCESSABLE_ENTITY = 422

  def self.pending_games
    @pending_games ||= Hash.new { |hash, key| hash[key] = Codebreaker::Game.new }
  end

  def initialize(player_name)
    @player_name = player_name
  end

  def hint
    { first_number: game.first_number }
  end

  def guess(input)
    if game.code_valid?(input)
      @latest_marks = game.guess(input)
      output = generate_output
      save_score          if game.win?
      remove_current_game if game.ended?
      output
    else
      {
        message: "Wrong input, you must enter #{game.code_length} numbers from 1 to 6",
        status: UNPROCESSABLE_ENTITY
      }
    end
  end

  def restart
    remove_current_game
    { attempts_left: game.attempts_left }
  end

  def code_length
    game.code_length
  end

  def attempts_left
    game.attempts_left
  end

  def scores
    Database.get_scores(@player_name)
  end

  private

  def game
    @game ||= WebGame.pending_games[@player_name]
  end

  def generate_output
    buffer = { marks: @latest_marks, attempts_left: attempts_left }
    if game.win?
      buffer[:win] = true
      buffer[:score] = game.statistic
    end
    if game.loose?
      buffer[:loose] = true
      buffer[:secret_code] = game.secret_code
    end
    buffer
  end

  def remove_current_game
    WebGame.pending_games.delete(@player_name)
  end

  def save_score
    Database.save_result(@player_name, game.statistic)
  end
end
