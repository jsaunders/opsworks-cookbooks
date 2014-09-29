script "install_dependencies" do
  interpreter "bash"
  user "root"
  cwd "/tmp"
  code <<-EOH

    ##### sudo apt-get -y update
    # suppress GRUB warning for unattended upgrade
    ##### export DEBIAN_FRONTEND=noninteractive
    ##### sudo apt-get -y upgrade

    sudo apt-get install -y git
    sudo apt-get install -y apache2
    sudo apt-get install -y libapache2-mod-wsgi
    sudo apt-get install -y python-pip
    sudo apt-get install -y python-psycopg2

    # disable default apache site
    sudo a2dissite 000-default

  EOH

end