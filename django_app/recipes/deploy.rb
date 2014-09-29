include_recipe 'deploy'

opsworks_deploy do
  deploy_data deploy
  app application
end



