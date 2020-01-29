// https://www.home-assistant.io/integrations/script/

local utils = (import 'utils.libsonnet');

{
  new(
    config,
  )::
    (config) + utils.hidden_fields,

  list(
    entities,
  )::
    {
      [entity.entity]:
        $.new(entity)
      for entity in entities
    },
}
