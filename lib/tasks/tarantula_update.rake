
namespace :tarantula do
  
  desc "Update Tarantula. Run on RAILS_ROOT." 
  task :update => :environment do
    system('git fetch')
    
    all_tags = IO.popen('git tag').read.split
    
    valid_tags = []
    all_tags.each do |tag|
      if tag  =~ /(\d{4})\.(\d{2})\.(\d{1,2})/
        year = $1
        week = $2.length == 1 ? "0"+$2 : $2
        rel = $3.length == 1 ? "0"+$3 : $3
        valid_tags << ["#{year}#{week}#{rel}".to_i, tag]
      end
    end
    valid_tags.sort!{|a,b| a[0] <=> b[0]}
    last_tag = valid_tags.last[1]
    
    system("git checkout #{last_tag}")
    Rake::Task['db:migrate'].execute
    FileUtils.touch(File.join(RAILS_ROOT, 'tmp','restart.txt'))
    system('/etc/init.d/delayed_job restart')
  end
end
