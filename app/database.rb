class Database
  DB_PATH = 'scores.yaml'.freeze

  class << self
    def get_scores(player_name)
      existing_data[player_name]
    end

    def save_result(player_name, result)
      scores = Hash.new { |hash, key| hash[key] = [] }
      scores.merge! existing_data
      scores[player_name] << result
      File.open(DB_PATH, 'w') { |f| f.write(YAML.dump(scores)) }
    end

    def existing_data
      return {} unless File.exist?(DB_PATH)
      YAML.load(File.read(DB_PATH)) || {}
    end
  end
end
