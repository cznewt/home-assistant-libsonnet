{
  new(
    config,
  )::
    {
      title: config.name,
      [if std.objectHas(config._dashboards, 'views') then 'views']: config._dashboards.views,
    },
}
