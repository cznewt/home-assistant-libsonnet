// https://www.home-assistant.io/integrations/input_number/

{
  new(
    config,
  )::
    {
      max: config.max,
      min: config.min,
      step: if std.objectHas(config, 'step') then config.step else 1,
      [if std.objectHas(config, 'initial') then 'initial']: config.initial,
    },

  list(
    entities,
  )::
    {
      [entity.entity]:
        $.new(entity)
      for entity in entities
    },
}
