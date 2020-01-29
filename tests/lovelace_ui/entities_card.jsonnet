local config = import '../../home-assistant-libsonnet/config.libsonnet';

local parameters = {
  id: 'media_sony_bravia_tv',
  name: 'TV',
};

config.new(
  frontend='lovelace',
  dashboards={
    views: [
      {
        title: '%(name)s Control' % parameters,
        type: 'entities',
        show_header_toggle: false,
        entities: [
          'input_select.%(id)s_sources' % parameters,
          'input_number.%(id)s_volume' % parameters,
          'automation.%(id)s_volume_init' % parameters,
          'automation.%(id)s_volume_update' % parameters,
        ],
      },
    ],
  },
)
