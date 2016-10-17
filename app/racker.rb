require 'rack'
require 'erb'

#
class Racker < WebGame
  def self.call(env)
    new(env).process.finish
  end

  def initialize(env)
    @request = Rack::Request.new(env)
  end

  def process
    case @request.path
    when '/' then player_name? ? render('game') : redirect_to('/login')
    when '/login' then render('login')
    when '/api/hint' then hint
    when '/api/guess' then guess
    when '/api/restart' then restart
    else redirect_to('/')
    end
  end

  private

  def render(page)
    file    = File.read("app/views/#{page}.html.erb")
    layouts = File.read('app/views/layout.html.erb')

    content = ERB.new(file).result(binding)
    final   = ERB.new(layouts).result(binding)

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

  def render_json(data, status = 200)
    Rack::Response.new(data.to_json, status, 'Content-Type' => 'application/json')
  end
end
