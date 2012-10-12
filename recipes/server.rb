#
# Cookbook Name:: Quantum 
# Recipe:: server
#
# Copyright 2012, DreamHost
#

rabbit_ip = IPManagement.get_ips_for_role("rabbitmq-server", "nova", node)[0]
keystone = get_settings_by_role("keystone", "keystone")
ks_admin_endpoint = get_access_endpoint("keystone", "keystone", "admin-api")
ks_service_endpoint = get_access_endpoint("keystone", "keystone", "service-api")

package "quantum-server" do
  action :install
end

template "/etc/quantum/quantum.conf" do
  source "quantum.conf.erb"
  owner "root"
  group "root"
  mode "0644"
  variables(
            "rabbit_ipaddress" => rabbit_ip
            )
end

template "/etc/quantum/api-paste.ini" do
    source "api-paste.ini.erb"
    owner "root"
    group "root"
    mode "0644"
    variables(
      "component"  => node["package_component"],
      "keystone_api_ipaddress" => ks_service_endpoint["host"],
      "service_port" => ks_service_endpoint["port"],
      "admin_port" => ks_admin_endpoint["port"],
      "admin_token" => keystone["admin_token"]
    )
 notifies :restart, resources(:service => "nova-api-os-compute"), :delayed
end


service "quantum-server" do
     action :restart
end
