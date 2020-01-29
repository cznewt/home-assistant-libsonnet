// https://www.home-assistant.io/integrations/climate/

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
    ],
}
