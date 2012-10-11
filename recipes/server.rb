#
# Cookbook Name:: Quantum 
# Recipe:: server
#
# Copyright 2012, DreamHost
#

rabbit_ip = IPManagement.get_ips_for_role("rabbitmq-server", "nova", node)[0]

package "quantum-server" do
  action :install
end

template "/etc/quantum/quantum.conf" do
  source "quantun.conf.erb"
  owner "root"
  group "root"
  mode "0644"
  variables(
            "rabbit_ipaddress" => rabbit_ip
            )

service "quantum-server" do
     action :restart
end

