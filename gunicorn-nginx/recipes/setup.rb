script "install_dependencies" do
  interpreter "bash"
  user "root"
  cwd "/tmp"
  code <<-EOH

    sudo apt-get update
    apt-get install -y python python-dev python-setuptools python-software-properties vim
    apt-get install -y libpq-dev
    apt-get install -y supervisor
    apt-get install -y git

    # add nginx stable ppa
    add-apt-repository -y ppa:nginx/stable
    # update packages after adding nginx repository
    apt-get update
    # install latest stable nginx
    apt-get install -y nginx
    apt-get install -y rabbitmq-server

    # install pip
    easy_install pip

    # install uwsgi now because it takes a little while
    sudo pip install uwsgi

    un useradd celeryuser
    apt-get install -y python-psycopg2

    # ubuntu pip package is currently broken
    # https://bugs.launchpad.net/ubuntu/+source/python-pip/+bug/1306991
    # curl --silent --show-error --retry 5 https://bootstrap.pypa.io/get-pip.py | sudo python2.7

    # install celery
    pip install celery==3.1.17

    # disable default apache site
    # a2dissite 000-default

  EOH

end