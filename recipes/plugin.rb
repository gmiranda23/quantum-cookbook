#
# Cookbook Name:: Quantum 
# Recipe:: plugin 
#
# Copyright 2012, DreamHost
# Copyright 2013, Opscode, Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

#TODO Figure out the providers for each plugin

case node["openstack"]["quantum"]["plugin"]
when "nicira"
  package "quantum-plugin-nicira" do
    action :install
  end
  provider = "quantum.plugins.nicira.nicira_nvp_plugin.QuantumPlugin.NvpPluginV2"
when "linuxbridge"
  package "quantum-plugin-linuxbridge-agent" do
    action :install
  end
  provider = "quantum.plugins.sample.SamplePlugin.FakePlugin"
when "cisco"
  package "quantum-plugin" do 
    action :install
  end
  provider = "quantum.plugins.sample.SamplePlugin.FakePlugin"
when "openvswitch"
  package "quantum-plugin-openvswitch" do
    action :install
  end
  provider = "quantum.plugins.sample.SamplePlugin.FakePlugin"
when "ryu"
  package "quantum-plugin-ryu" do
    action :install
  end
  provider = "quantum.plugins.ryu.ryu_quantum_plugin.RyuQuantumPluginV2"
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
    "mysql_user" => node["openstack"]["quantum"]["db"]["username"],
    "tz_uuid" => node["quantum"]["plugin"]["nvp"]["tz_uuid"]
  )
end

service "quantum-server" do
     action :restart
end

