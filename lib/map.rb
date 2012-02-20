class Map < Array

  def initialize(jira_name)
    self[0] = jira_name
  end

  def jira_name
    self[0]
  end

  def jira_custom_field
    return self[1]
  end

  def jira_custom_field=(value)
    self[1] = value
  end
end
