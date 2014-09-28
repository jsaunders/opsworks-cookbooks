node[:deploy].each do |application, deploy|

    file "/home/ubuntu/.ssh/id_rsa" do
        content application['scm']['ssh_key']
    end

    execute "chmod deploy key" do
        command "chmod 600 /home/ubuntu/.ssh/id_rsa"
    end

end




