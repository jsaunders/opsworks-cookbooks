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
    sudo a2dissite 000-default

    sudo cat >> /etc/apache2/sites-available/site.conf << EOF
<VirtualHost *:80>

    ErrorLog /var/log/apache2/error.log
    CustomLog /var/log/apache2/access.log combined

    Alias /static/ /home/ubuntu/$REPO_NAME/source/static/
    Alias /robots.txt /home/ubuntu/$REPO_NAME/source/static/robots.txt
    Alias /favicon.ico /home/ubuntu/$REPO_NAME/source/static/favicon.ico

    <Directory /home/ubuntu/$REPO_NAME/source/static/>
        Order deny,allow
        Require all granted
    </Directory>

    <Directory /home/ubuntu/$REPO_NAME/source/$PROJECT_NAME>
        <Files wsgi.py>
            Order deny,allow
            Require all granted
        </Files>
    </Directory>

    SetEnv DJANGO_SETTINGS_MODULE $PROJECT_NAME.settings.base

</VirtualHost>

WSGIScriptAlias / /home/ubuntu/$REPO_NAME/source/$PROJECT_NAME/wsgi.py
WSGIPythonPath /home/ubuntu/$PROJECT_NAME/source
EOF

    ### temp deploy code ###
    sudo git clone git://github.com/abrinsmead/django_test_project.git ~/django_test_project
    sudo pip install django

    sudo chown -R ubuntu /home/ubuntu/$REPO_NAME
    sudo chmod o+r /home/ubuntu/$REPO_NAME/source/$PROJECT_NAME/wsgi.py
    sudo chmod o+x /home/ubuntu/$REPO_NAME/source
    sudo chmod o+x /home/ubuntu/$REPO_NAME
    sudo chmod o+x /home/ubuntu
    sudo chmod o+x /home

    sudo a2ensite site
    sudo service apache2 reload
    sudo service apache2 start

  EOH

end