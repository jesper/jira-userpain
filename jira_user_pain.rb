#!/usr/bin/env ruby

require 'rubygems'
require 'sinatra/base'
require './helpers'

class JiraUserPain < Sinatra::Base

  get "/" do
    "Hello World"
  end

  run! if __FILE__ == $0
end

