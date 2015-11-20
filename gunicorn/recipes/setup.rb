include_recipe 'gunicorn'

script "install_dependencies" do
  interpreter "bash"
  user "root"
  cwd "/tmp"
  code <<-EOH

    sudo apt-get update
    apt-get install -y python python-dev python-setuptools python-software-properties vim
    apt-get install -y git

    sudo pip install uwsgi

    apt-get install -y rabbitmq-server

    useradd celeryuser
    apt-get install -y python-psycopg2


  EOH

end