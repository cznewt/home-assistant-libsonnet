// https://www.home-assistant.io/integrations/input_text/

{
  new(
    config,
  )::
    {
      name: config.name,
      [if std.objectHas(config, 'min') then 'min']: config.min,
      [if std.objectHas(config, 'max') then 'max']: config.max,
      [if std.objectHas(config, 'initial') then 'initial']: config.initial,
      [if std.objectHas(config, 'pattern') then 'pattern']: config.pattern,
      [if std.objectHas(config, 'mode') then 'mode']: config.mode,
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
