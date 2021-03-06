require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')
require File.expand_path(File.dirname(__FILE__) + '/../shared/cacheable_report_spec.rb')

describe Report::DailyProgress do
  def get_instance(opts={})
    return Report::DailyProgress.new(1,1,1) if opts[:static]
    
    p = Project.make
    to = TestObject.make(:project => p)
    Report::DailyProgress.new(p.id, to.id)
  end
  it_should_behave_like "cacheable report"
end
