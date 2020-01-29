local config = import '../../home-assistant-libsonnet/config.libsonnet';

local parameters = {
  host: '<<hostname/ip>>',
  username: '<<password>>',
};

config.new(
  components={
    phillips_hue_gateway: {
      kind: 'hue',
      host: parameters.host,
      username: parameters.username,
      allow_unreachable: true,
      allow_hue_groups: true,
    },
  },
)
