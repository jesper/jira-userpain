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

end
