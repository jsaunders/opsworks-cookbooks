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
     :project_path => "fe/fi/fo/fum,
     :project_name => "foo"
  })
end