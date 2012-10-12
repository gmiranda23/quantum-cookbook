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

service "quantum-server" do
     action :restart
end

