require 'rubygems'

require 'net/http'
require 'json'
require 'nokogiri'

require './lib/assert'

def type_to_value(type)
  case type
    when /Crash/
      return 7
    when /Security/
      return 6
    when /Major/
      return 5
    when /Minor/
      return 4
    when /Cosmetic/
      return 3
    when /Localization/
      return 2
    when /Documentation/
      return 1
    else
      assert(false, "Invalid likelihood #{likelihood} given to likelihood_to_value")
  end
end

def likelihood_to_value(likelihood)
  case likelihood
    when /Most/
      return 5
    when /Many/
      return 4
    when /Minority/
      return 3;
    when /Very/
      return 2;
    when /Almost/
      return 1;
    else
      assert(false, "Invalid likelihood #{likelihood} given to likelihood_to_value")
   end
end

def priority_to_value(priority)
  case priority
    when /Blocker/
      return 5
    when /Critical/
      return 4
    when /Major/
      return 3
    when /Minor/
      return 2
    when /Trivial/
      return 1
    else
      assert(false, "Invalid priority #{priority} given to priority_to_value")
  end
end

def get_user_pain_score(priority, likelihood, type)
  (((priority_to_value(priority) * likelihood_to_value(likelihood) * type_to_value(type)) / 175.0) * 100).round
end

def get_issues_for_project(project, threshold)
  issues_xml = search_for_issues(project)

  issues = Array.new

  issue_xpath = Nokogiri::XML(issues_xml).xpath('//rss/channel/item')

  for issue in issue_xpath
    priority = issue.xpath('priority').text
    likelihood = issue.xpath('customfields/customfield[customfieldname = "Likelihood"]/customfieldvalues/customfieldvalue').text
    type = issue.xpath('customfields/customfield[customfieldname = "Classification"]/customfieldvalues/customfieldvalue').text

    score = get_user_pain_score(priority, likelihood, type)
    if (score < threshold.to_i)
      next
    end

    id = issue.xpath('key').text
    assignee = issue.xpath('assignee').attribute('username').text
    summary = issue.xpath('summary').text
    issues.push({:id => id, :assignee => assignee, :userpain => score, :summary => summary})
  end

  return {:issues => issues}
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
    raise StandardError, "Unsuccessful response code " + response.code + " for project " + project
  end
end
