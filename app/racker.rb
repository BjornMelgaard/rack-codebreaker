require 'rack'
require 'erb'
require_relative 'web_game'

class Racker
  def self.call(env)
    new(env).process.finish
  end

  def initialize(env)
    @request = Rack::Request.new(env)
    @game = WebGame.new(player_name) if player_name?
  end

  def process
    return redirect_to('/login') if !player_name? && @request.path != '/login'

    case @request.path
    when '/'            then render('game')
    when '/login'       then render('login')
    when '/api/hint'    then render_json @game.hint
    when '/api/guess'   then render_json @game.guess(@request.params['guess'])
    when '/api/restart' then render_json @game.restart
    else redirect_to('/')
    end
  end

  private

  def render(page)
    file   = File.read("app/views/#{page}.html.erb")
    layout = File.read('app/views/layout.html.erb')

    content = ERB.new(file).result(binding)
    final   = ERB.new(layout).result(binding)

    Rack::Response.new(final)
  end

  def redirect_to(path)
    Rack::Response.new do |response|
      response.redirect(path)
    end
  end

  def player_name
    @request.cookies['player_name']
  end

  def player_name?
    !player_name.nil? && !player_name.empty?
  end

  def render_json(data = {})
    status = data.delete(:status) || 200
    Rack::Response.new(data.to_json, status, 'Content-Type' => 'application/json')
  end
end
