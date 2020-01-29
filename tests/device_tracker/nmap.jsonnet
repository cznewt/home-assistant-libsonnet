local config = import '../../home-assistant-libsonnet/config.libsonnet';

local parameters = {
  id: 'presence_nmap',
  name: 'NMAP Tracker',
  hosts: '10.0.0.*',
};

config.new(
  entities={
    presence_nmap: {
      device_tracker: {
        ['%(id)s_tracker' % parameters]: {
          home_interval: 5,
          hosts: parameters.hosts,
          interval_seconds: 30,
          platform: 'nmap_tracker',
          scan_options: ' --privileged -sP ',
        },
      },
    },
  },
)
