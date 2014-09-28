script "install_dependencies" do
  interpreter "bash"
  user "root"
  cwd "/tmp"
  code <<-EOH

    # Minimum expected project repo structure:
    #   - your_repo (repo_name)
    #     - source
    #       - requirements (pip requirements format. One file per environment)
    #         - production.txt
    #         - staging.txt
    #         - etc...
    #       - static
    #       - your_project (project_name)
    #         - wsgi.py
    #
    # OpsWorks custom JSON example:
    # {
    #   "django_app" : {
    #       "repo_name" : "foo.example.com"
    #       "project_name" : "foo"
    #   }
    # }

    REPO_NAME=#{node['django_app']['repo_name']}
    PROJECT_NAME=#{node['django_app']['project_name']}

    ##### sudo apt-get -y update
    # suppress GRUB warning for unattended upgrade
    ##### export DEBIAN_FRONTEND=noninteractive
    ##### sudo apt-get -y upgrade

    sudo apt-get install -y git
    sudo apt-get install -y apache2
    sudo apt-get install -y libapache2-mod-wsgi
    sudo apt-get install -y python-pip
    sudo apt-get install -y python-psycopg2

    #disable default apache site
    #sudo a2dissite 000-default

  EOH

end