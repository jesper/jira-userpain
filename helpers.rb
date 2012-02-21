require 'rubygems'

require 'net/http'
require 'json'
require 'nokogiri'

require './lib/assert'

$LIKELIHOOD = 'Likelihood'
$TYPE = 'Classification'
$USERPAIN_THRESHOLD = 30

def get_issues_for_project(project)
  issues_xml = search_for_issues(project)
  issues = Array.new

  issue_xpath = Nokogiri::XML(issues_xml).xpath('//rss/channel/item')

  for issue in issue_xpath
    id = issue.xpath('key').text
    assignee = issue.xpath('assignee').attribute('username').text
    priority = issue.xpath('priority').text
    likelihood = issue.xpath('customfields/customfield[customfieldname = "Likelihood"]/customfieldvalues/customfieldvalue').text
    type = issue.xpath('customfields/customfield[customfieldname = "Classification"]/customfieldvalues/customfieldvalue').text
    summary = issue.xpath('summary').text
    issues.push({:id => id, :assignee => assignee, :priority => priority, :likelihood => likelihood, :type => type, :summary => summary})
  end

  return issues
end

def search_for_issues(project)
  req = Net::HTTP::Get.new(URI.escape('/sr/jira.issueviews:searchrequest-xml/temp/SearchRequest.xml?field=key&field=summary&field=assignee&field=priority&field=allcustom&jqlQuery=' + $LIKELIHOOD + ' != EMPTY AND ' + $TYPE + ' != EMPTY AND priority != EMPTY AND status != closed AND type = bug AND project=' + project))
  req.basic_auth(ENV['JIRA_USERNAME'], ENV['JIRA_PASSWORD'])
  response = Net::HTTP.new(ENV['JIRA_HOSTNAME'], ENV['JIRA_PORT']).request(req)

  if response.code =~ /20[0-9]{1}/
#TBD handle invalid xml properly
    return response.body
  else
#TBD Add more graceful error handling
    raise StandardError, "Unsuccessful response code " + response.code + " for issue " + issue
  end
end
