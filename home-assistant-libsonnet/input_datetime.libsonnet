// https://www.home-assistant.io/integrations/input_datetime/

{
  new(
    config,
  )::
    {
      name: config.name,
      [if std.objectHas(config, 'has_time') then 'has_time']: config.has_time,
      [if std.objectHas(config, 'has_date') then 'max']: config.has_date,
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
