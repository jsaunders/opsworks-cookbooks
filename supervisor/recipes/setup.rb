include_recipe 'supervisor'


supervisor_service "app-uwsgi" do
  action :enable
  autostart false
  command '/usr/local/bin/uwsgi --ini /home/ubuntu/bespoke/current/uwsgi.ini'

end