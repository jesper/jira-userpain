#!/usr/bin/env ruby

require 'rubygems'
require 'sinatra/base'
require './helpers'

class JiraUserPain < Sinatra::Base

  get "/" do
    "Jira UserPain dashboard. Call /dashboard.json/$project"
  end

  get '/dashboard.json/:project/?:threshold?' do
    content_type :json
    params['threshold'] ||= $USERPAIN_THRESHOLD
    get_issues_for_project(params['project']).to_json
  end

  run! if __FILE__ == $0
end

