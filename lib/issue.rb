class Issue
  attr_accessor :id, :assignee, :priority, :likelihood, :type, :summary

  def initialize(id, assignee, priority, likelihood, type, summary)
    @id = id
    @assignee = assignee
    @priority = priority
    @likelihood = likelihood
    @type = type
    @summary = summary
  end

  def to_s
    "#{@id} - #{@summary} [#{@assignee}]"
  end
end
