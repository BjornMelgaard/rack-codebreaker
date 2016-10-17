require 'bundler/setup'
require 'sprockets'
require 'autoprefixer-rails'
require_relative 'app/web_game'
require_relative 'app/racker'

use Rack::Reloader

assets = Sprockets::Environment.new do |env|
  env.append_path 'app/assets/images'
  env.append_path 'app/assets/javascripts'
  env.append_path 'app/assets/stylesheets'
  env.js_compressor  = :uglify
  env.css_compressor = :scss
end

AutoprefixerRails.install(assets)

map '/assets' do
  run assets
end

map '/' do
  run Racker
end
