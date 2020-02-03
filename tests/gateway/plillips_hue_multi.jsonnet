local config = import '../../home-assistant-libsonnet/config.libsonnet';

local gateway_01_parameters = {
  host: '<<hostname/ip1>>',
  username: '<<password1>>',
};

local gateway_02_parameters = {
  host: '<<hostname/ip2>>',
  username: '<<password2>>',
};

config.new(
  components={
    phillips_hue_gateway_01: {
      kind: 'hue',
      host: gateway_01_parameters.host,
      username: gateway_01_parameters.username,
      allow_unreachable: true,
      allow_hue_groups: true,
    },
    phillips_hue_gateway_02: {
      kind: 'hue',
      host: gateway_02_parameters.host,
      username: gateway_02_parameters.username,
      allow_unreachable: true,
      allow_hue_groups: true,
    },
  },
)
