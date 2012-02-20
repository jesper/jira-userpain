require './jira_user_pain'
gem 'test-unit'
require 'test/unit'
require 'rack/test'

class JiraUserPainTest < Test::Unit::TestCase
  include Rack::Test::Methods

  def app
    JiraUserPain
  end

  def test_root
    get '/'
    assert_equal('Hello World', last_response.body)
  end

  def test_dashboard_single_ticket_json
    get '/dashboard.json', :project => 'single_ticket'
    json = { :tickets => [{:id => 1, :pain => 10, :summary=>'First ticket with pain of ten'}]}.to_json
    assert_equal(json, last_response.body)
  end

end
