#!/usr/bin/env ruby

require 'rubygems'
require 'sinatra/base'
require './helpers'

class JiraUserPain < Sinatra::Base

  get "/" do
    "Hello World"
  end

  run! if app_file == $0
end

