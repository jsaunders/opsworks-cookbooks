include_recipe 'deploy'


project_path = node[:django_app][:project_path]
project_name = node[:django_app][:project_name]
requirements_path = node[:django_app][:requirements_path]
htpasswd = node[:django_app][:htpasswd]
force_https = node[:django_app][:force_https]

node[:deploy].each do |application, deploy|

    opsworks_deploy do
      app application
      deploy_data deploy
    end


    template '/etc/init.d/celeryd' do
        source 'celeryd_init.erb'
        owner 'root'
        group 'root'
        mode '755'
    end

    template '/etc/default/celeryd' do
        source 'celeryd_conf.erb'
        owner 'root'
        group 'root'
        mode '600'
        variables({
            :project_path => project_path,
            :project_name => project_name,
            :environment => deploy[:environment_variables]
        })
    end


    # Export env variables so migrate can access DJANGO_SETTINGS_FILE
    deploy[:environment_variables].each do |key, value|
        ENV[key] = value
    end

end


script "install dependencies and activate" do
  interpreter "bash"
  user "root"
  code <<-EOH

    # install requirements from text file
    pip install -r "#{requirements_path}"

    # run migrations
    python #{project_path}/manage.py migrate

    # start or restart celery
    sudo service celeryd restart
    sudo supervisorctl restart all

    printenv >> /home/ubuntu/temp1.txt



    EOH

end