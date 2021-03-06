namespace :tarantula do
  desc "Initialize new database. " +
    " Creates admin user with login = admin, password = admin." +
    " Create also default project."
  task :init_db => :environment do

    project = Project.create!(:name => "Default Project")

    Admin.create!(
      :email => CustomerConfig.admin_email,
      :login => "admin",
      :password => "admin",
      :password_confirmation => "admin",
      :admin => true,
      :latest_project_id => project.id)

    puts "User login admin with password admin created."
    puts "Please remember to change password!"
    puts "(You can use testia:reset_password task or " +
      "Tarantula User Profile interface.)"
  end
end
