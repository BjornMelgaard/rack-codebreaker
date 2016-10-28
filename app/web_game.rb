require 'codebreaker'
require 'yaml'
require_relative 'database'

#
class WebGame
  UNPROCESSABLE_ENTITY = 422

  @@pending_games = Hash.new { |hash, key| hash[key] = Codebreaker::Game.new }

  def initialize(player_name)
    @player_name = player_name
  end

  def hint
    { first_number: game.first_number }
  end

  def guess(input)
    if game.code_valid?(input)
      @output = { marks: game.guess(input) }
      win      if game.win?
      loose    if game.loose?
      end_game if game.ended?
      @output
    else
      { message: 'Wrong input', status: UNPROCESSABLE_ENTITY }
    end
  end

  def restart
    end_game
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
    @@pending_games[@player_name]
  end

  def win
    @output[:win] = true
    @output[:score] = game.statistic
    save_score
  end

  def loose
    @output[:loose] = true
    @output[:secret_code] = game.secret_code
  end

  def end_game
    @@pending_games.delete(@player_name)
  end

  def save_score
    Database.save_result(@player_name, game.statistic)
  end
end
