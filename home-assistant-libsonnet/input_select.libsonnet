// https://www.home-assistant.io/integrations/input_select/

{
  new(
    config,
  )::
    {
      options: config.options,
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
