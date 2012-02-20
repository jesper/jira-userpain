#!/usr/bin/env ruby

require 'rubygems'
require 'net/http'
require 'json'
require 'lib/map.rb'
require 'lib/assert.rb'
require 'lib/issue.rb'

# Map user-pain field name to what the field is called in your instance of Jira. Map is declared in lib/map.rb.
$mapping = {'likelihood' => Map.new('Likelihood'), 'type' => Map.new('Classification'), 'priorty' => Map.new('Priority')}

def get_value(field_name, data)
  if field_name == 'priority'
    return data['priority']['value']['name'] 
  end

  if !$mapping[field_name].jira_custom_field
    $mapping[field_name].jira_custom_field = data.keys.select{ |k| data[k]['name'] == $mapping[field_name].jira_name }.first
  end

  assert(!data[$mapping[field_name].jira_custom_field]['value'].nil?, "#{field_name} field value not found in data")

  return data[$mapping[field_name].jira_custom_field]['value']['value']
end

def get_issue(issue)
  req = Net::HTTP::Get.new('/rest/api/latest/issue/' + issue + '.json')
  req.basic_auth(ENV['JIRA_USERNAME'], ENV['JIRA_PASSWORD'])

  response = Net::HTTP.new(ENV['JIRA_HOSTNAME'], ENV['JIRA_PORT']).request(req)

  if response.code =~ /20[0-9]{1}/
    json = JSON.parse(response.body)
    data = json['fields']
    return Issue.new(issue,
                     data['assignee']['value']['name'],
                     get_value('priority', data),
                     get_value('likelihood', data),
                     get_value('type', data),
                     data['summary']['value'])
  else
    raise StandardError, "Unsuccessful response code " + response.code + " for issue " + issue
  end
end
