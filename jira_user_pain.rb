#!/usr/bin/env ruby

require 'rubygems'
require 'sinatra/base'
require './helpers'

class JiraUserPain < Sinatra::Base

  get '/' do
    'Jira UserPain dashboard. Call /dashboard/$project'
  end

  get '/dashboard/:project/?:threshold?' do
    haml :dashboard
  end

  get '/dashboard.json/:project/?:threshold?' do
    content_type :json
    get_issues_for_project(params['project'], params['threshold']).to_json
  end

  post '/dashboard.json/:project/?:threshold?' do
    content_type :json
    get_issues_for_project(params['project'], params['threshold']).to_json
  end

  run! if __FILE__ == $0
end

