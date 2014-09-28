script "deploy_app" do
  interpreter "bash"
  user "root"
  cwd "/tmp"
  code <<-EOH

    PROJECT_NAME=#{node['django_app']['app_name']}

    chown -R ubuntu /home/ubuntu/$PROJECT_NAME

    chmod o+r /home/ubuntu/$PROJECT_NAME/$PROJECT_NAME/$PROJECT_NAME/wsgi.py
    chmod o+x /home/ubuntu/$PROJECT_NAME/$PROJECT_NAME
    chmod o+x /home/ubuntu/$PROJECT_NAME
    chmod o+x /home/ubuntu
    chmod o+x /home

    #todo: install pip dependencies
    #todo: syncdb/migrate

    #restart apache
    sudo service apache2 restart

  EOH
end