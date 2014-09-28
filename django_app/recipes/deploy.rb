node[:deploy].each do |application, deploy|

    clone_repo = application['scm']['repository']["https://github.com/"]=""

    file "/home/ubuntu/clone_repo.log" do
        content clone_repo
    end

    file "/home/ubuntu/.ssh/id_rsa" do
        content application['scm']['ssh_key']
    end

    execute "chmod deploy key" do
        command "chmod 600 /home/ubuntu/.ssh/id_rsa"
    end

end




