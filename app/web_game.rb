require 'codebreaker'
require 'yaml'
#
class WebGame
  UNPROCESSABLE_ENTITY = 422
  SCORES_PATH = 'scores.yaml'.freeze

  @@pending_games = Hash.new { |hash, key| hash[key] = Codebreaker::Game.new }
  @@scores = Hash.new { |hash, key| hash[key] = [] }

  if File.exist?(SCORES_PATH)
    puts "load scores"
    serialized_scores = File.read(SCORES_PATH)
    scores = YAML.load(serialized_scores)
    @@scores.merge!(scores)
  end

  def initialize(player_name)
    @player_name = player_name
  end

  def hint
    puts game.instance_variable_get(:@secret)
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
    @@scores[@player_name]
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
    @@scores[@player_name] << game.statistic
    serialized = YAML.dump(@@scores)
    File.open(SCORES_PATH, 'w') { |f| f.write(serialized) }
  end
end
