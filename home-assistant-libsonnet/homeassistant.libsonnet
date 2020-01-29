{
  new(
    config,
    customize
  )::
    {
      name: config.name,
      [if std.objectHas(config, 'password') then 'auth_providers']: [
        { type: 'homeassistant' },
        {
          type: 'legacy_api_password',
          [if std.objectHas(config, 'password') then 'api_password']: config.password,
        },
      ],
      [if std.objectHas(config, 'temperature_unit') then 'temperature_unit']: config.temperature_unit,
      [if std.objectHas(config, 'unit_system') then 'unit_system']: config.unit_system,
      [if std.objectHas(config, 'time_zone') then 'time_zone']: config.time_zone,
      [if std.objectHas(config, 'latitude') then 'latitude']: config.latitude,
      [if std.objectHas(config, 'longitude') then 'longitude']: config.longitude,
      [if std.objectHas(config, 'elevation') then 'elevation']: config.elevation,
      [if std.length(customize) > 0 then 'customize']: customize,
    },
}
