// https://www.home-assistant.io/integrations/binary_sensor/

local utils = (import 'utils.libsonnet');

{
  new(
    config,
  )::
    (config) + utils.hidden_fields,

  list(
    entities,
  )::
    [
      $.new(entity)
      for entity in entities
      if entity.platform != 'template' && entity.platform != 'customize'
    ] + [
      {
        platform: 'template',
        sensors: {
          [entity.entity]:
            $.new((entity) + { platform:: null } + utils.hidden_fields)
          for entity in entities
          if entity.platform == 'template'
        },
      },
    ],
}
