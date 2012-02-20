#!/usr/bin/env ruby

require 'rubygems'
require 'sinatra/base'
require './helpers'

class JiraUserPain < Sinatra::Base

  get "/" do
    "Hello World"
  end

  get '/dashboard.json(?|/):project' do
    {:tickets => [{:id=>1, :pain=>10, :summary=>'First ticket with pain of ten'}]}.to_json
  end

  run! if __FILE__ == $0
end

