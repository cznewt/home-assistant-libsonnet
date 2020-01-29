// https://www.home-assistant.io/integrations/switch/

local utils = (import 'utils.libsonnet');

{
  _calculate_broadlink(metadata):: {
    data:
      {
        platform: 'broadlink',
        switches: {
          [entity.id]:
            entity
            {
              platform:: null,
              instance:: null,
            }
          for entity in metadata.entities
          if entity.domain == 'switch' && entity.platform == 'broadlink'
        },
      } + {
        ['host']: component.host
        for component in metadata.components
        if component.kind == 'broadlink'
      } + {
        ['mac']: component.mac
        for component in metadata.components
        if component.kind == 'broadlink'
      } + {
        ['type']: component.type
        for component in metadata.components
        if component.kind == 'broadlink'
      },
  },

  new(
    config,
  )::
    (config) + utils.hidden_fields,

  list(
    entities,
  )::
    [
      $._calculate_broadlink(entities).data,
    ] + [
      {
        [entity.entity]: $.new(entity),
      }
      for entity in entities
      if entity.platform != 'broadlink'
    ],

}
