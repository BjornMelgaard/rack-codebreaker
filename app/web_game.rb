require 'codebreaker'
require 'yaml'
#
class WebGame
  UNPROCESSABLE_ENTITY = 422
  SCORES_PATH = 'scores.yaml'.freeze

  @@pending_games = Hash.new { |hash, key| hash[key] = Codebreaker::Game.new }
  @@scores = Hash.new { |hash, key| hash[key] = [] }

  File.open(SCORES_PATH, 'r') do |file|
    scores = YAML.load(file.read)
    @@scores.merge!(scores)
  end

  def game
    @@pending_games[player_name]
  end

  def hint
    puts game.instance_variable_get(:@secret)
    render_json game.first_number
  end

  def guess
    input = @request.params['input']
    if @request.post? && game.code_valid?(input)
      marks = game.guess(input)
      output = { marks: marks, win: game.win?, loose: game.loose? }
      if game.win?
        output[:score] = game.statistic
        save_score
      elsif game.loose?
        output[:secret_code] = game.secret_code
      end
      @@pending_games.delete(player_name) if game.ended?
      render_json output
    else
      render_json({ message: 'Wrong input' }, UNPROCESSABLE_ENTITY)
    end
  end

  def restart
    @@pending_games.delete(player_name)
    render_json game.attempts_left
  end

  def scores
    @@scores[player_name]
  end

  def self.load_scores
  end

  private

  def save_score
    @@scores[player_name] << game.statistic
    serialized = YAML.dump(@@scores)
    File.open(SCORES_PATH, 'w') { |f| f.write(serialized) }
  end
end
