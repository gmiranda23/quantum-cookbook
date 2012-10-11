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
when "linuxbridge"
  package "quantum-plugin-linuxbridge-agent" do
    action :install
when "cisco"
  package "quantum-plugin" do 
    action :install
when "openvswitch"
  package "quantum-plugin-openvswitch" do
    action :install
when "ryu"
  package "quantum-plugin-ryu" do
    action :install

template "/etc/quantum/plugins.ini" do
  source "plugins.ini.erb"
  owner "root"
  group "root"
  mode "0644"
  variables(
            "plugin_provider" => provider
            )

service "quantum-server" do
     action :restart
end

