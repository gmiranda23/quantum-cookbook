#
# Cookbook Name:: Quantum 
# Recipe:: plugin 
#
# Copyright 2012, DreamHost
#


#TODO Figure out the providers for each plugin
provider = "quantum.plugins.sample.SamplePlugin.FakePlugin"

case node["openstack"]["quantum"]["plugin"]
when "nicira"
  package "quantum-plugin-nicira" do
    action :install
  end
when "linuxbridge"
  package "quantum-plugin-linuxbridge-agent" do
    action :install
  end
when "cisco"
  package "quantum-plugin" do 
    action :install
  end
when "openvswitch"
  package "quantum-plugin-openvswitch" do
    action :install
  end
when "ryu"
  package "quantum-plugin-ryu" do
    action :install
  end
end

template "/etc/quantum/plugins.ini" do
  source "plugins.ini.erb"
  owner "root"
  group "root"
  mode "0644"
  variables(
            "plugin_provider" => provider
            )
end

mysql_info = get_settings_by_role("mysql-master", "mysql")

create_db_and_user("mysql",
                    node["openstack"]["quantum"]["db"]["name"],
                    node["openstack"]["quantum"]["db"]["username"],
                    node["openstack"]["quantum"]["db"]["password"])

template "/etc/quantum/plugins/nicira/nvp.ini" do
  source "plugins/nicira/nvp.ini.erb"
  owner "root"
  group "root"
  mode "0644"
  variables(
    "mysql_pass" => node["openstack"]["quantum"]["db"]["password"],
    "mysql_host" => mysql_info["bind_address"],
    "mysql_user" => node["openstack"]["quantum"]["db"]["username"]
  )
end

service "quantum-server" do
     action :restart
end

