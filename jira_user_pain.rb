#!/usr/bin/env ruby

require 'rubygems'
require 'sinatra/base'
require './helpers'

class JiraUserPain < Sinatra::Base
  set :static, true
  set :public, 'public'

  get '/' do
    'Jira UserPain dashboard. Call /$project'
  end

  get '/:project/?:threshold?' do
    haml :dashboard
  end

  get '/json/:project/?:threshold?' do
    content_type :json
    get_issues_for_project(params['project'], params['threshold']).to_json
  end

  post '/json/:project/?:threshold?' do
    content_type :json
    get_issues_for_project(params['project'], params['threshold']).to_json
  end

  run! if __FILE__ == $0
end

