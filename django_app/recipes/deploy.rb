include_recipe 'deploy'

node[:deploy].each do |application, deploy|

    opsworks_deploy do
      app application
      deploy_data deploy
    end

    template "/etc/apache2/sites-available/site.conf" do
        source "site.erb"
        owner 'root'
        group 'root'
        variables({
            :project_path => node[:django_app][:project_path],
            :project_name => node[:django_app][:project_name],
            :environment => deploy[:environment_variables]
        })
    end

end


# Export env variables so migrate can access DJANGO_SETTINGS_FILE
environment = deploy[:environment_variables]
environment.each do |key, value|
    ENV[key] = value
end


script "install dependencies and activate" do
  interpreter "bash"
  user "root"
  code <<-EOH

    # install requirements from text file
    pip install -r "#{node[:django_app][:requirements_path]}"

    # run migrations
    python #{node[:django_app][:project_path]}/manage.py migrate

    a2ensite site
    service apache2 reload
    service apache2 start

    EOH

end