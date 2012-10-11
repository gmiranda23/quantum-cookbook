########################################################################
# Toggles - These can be overridden at the environment level
default["enable_monit"] = false  # OS provides packages
default["developer_mode"] = false  # we want secure passwords by default
########################################################################

default["openstack"]["quantum"]["folsom"]["version"] = "2012.2+git201209242000~precise-0ubuntu1"
