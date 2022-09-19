require 'bundler/inline'

gemfile do
  source 'https://rubygems.org'
  # gem 'byebug'
end

Dir.glob(File.join('./lib', '**', '*.rb'), &method(:require))