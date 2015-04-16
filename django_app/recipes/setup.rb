script "install_dependencies" do
  interpreter "bash"
  user "root"
  cwd "/tmp"
  code <<-EOH

    sudo apt-get update
    apt-get install -y git
    apt-get install -y apache2
    apt-get install -y libapache2-mod-wsgi
    apt-get install -y python-psycopg2

    # ubuntu pip package is currently broken
    # https://bugs.launchpad.net/ubuntu/+source/python-pip/+bug/1306991
    curl --silent --show-error --retry 5 https://bootstrap.pypa.io/get-pip.py | sudo python2.7

    # install celery
    pip install celery==3.1.17

    # disable default apache site
    a2dissite 000-default

  EOH

end