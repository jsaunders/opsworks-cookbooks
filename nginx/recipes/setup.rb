package "nginx" do
  :upgrade
end

service "nginx" do
  enabled true
  running true
  supports :status => true, :restart => true, :reload => true
  action [:start, :enable]
end


cookbook_file "/etc/nginx/sites-available/nginx" do
  source "nginx-app.conf"
  mode 0640
  owner "root"
  group "root"
  notifies :restart, resources(:service => "nginx")

end