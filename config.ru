require 'bundler/setup'
require 'sprockets'
require 'autoprefixer-rails'

if ENV['RACK_ENV'] == 'development'
  require 'rack-livereload'
  use Rack::LiveReload
end

$LOAD_PATH.unshift File.expand_path('../app', __FILE__)
require 'racker'

assets = Sprockets::Environment.new do |env|
  env.append_path 'app/assets/images'
  env.append_path 'app/assets/javascripts'
  env.append_path 'app/assets/stylesheets'
  env.js_compressor  = :uglify if ENV['RACK_ENV'] != 'development'
  env.css_compressor = :scss
end

AutoprefixerRails.install(assets)

map '/assets' do
  run assets
end

map '/' do
  run Racker
end
