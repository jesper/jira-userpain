#!/usr/bin/env ruby

require 'rubygems'
require 'sinatra/base'
require './helpers'

class JiraUserPain < Sinatra::Base

  get "/" do
    "Hello World"
  end

  get '/dashboard.json[?|/]:project' do
    content_type :json
    get_issues_for_project(params['project']).to_json
  end

  run! if __FILE__ == $0
end

