include_recipe 'deploy'

node[:deploy].each do |application, deploy|
    opsworks_deploy do
      deploy_data deploy
      app application
    end
end

template "/etc/apache2/sites-available/site.conf" do
  source "site.erb"
  owner 'root'
  group 'root'
  variables({
     :project_path => node[:django_app][:project_path],
     :project_name => node[:django_app][:project_name],
     :environment => "todo: pass env array and set in apache config"
  })
end

script "install dependencies and activate" do
  interpreter "bash"
  user "ubuntu"
  cwd "/home/ubuntu/"
  code <<-EOH

    #todo: install requirements from text file
    sudo pip install django

    #todo: migrations

    sudo a2dissite 000-default
    sudo a2ensite site
    sudo service apache2 reload
    sudo service apache2 start

    EOH

end