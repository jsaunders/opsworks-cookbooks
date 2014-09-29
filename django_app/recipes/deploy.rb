include_recipe 'deploy'

node[:deploy].each do |application, deploy|

    opsworks_deploy do
      deploy_data deploy
      app application
    end

end


