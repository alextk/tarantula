require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')
require File.expand_path(File.dirname(__FILE__) + '/../shared/cacheable_report_spec.rb')

describe Report::WeeklyEfficiency do
  def get_instance(opts={})
    if opts[:static]
      return Report::WeeklyEfficiency.new(1, nil, nil, Date.parse('2009-01-01'),
                                          Date.parse('2009-01-31'))
    end                                    
    
    p = Project.make(:bug_tracker => Bugzilla.make)
    Report::WeeklyEfficiency.new(p.id, nil, nil, 1.week.ago.to_date, Date.today)
  end
  
  it_should_behave_like "cacheable report"
end
