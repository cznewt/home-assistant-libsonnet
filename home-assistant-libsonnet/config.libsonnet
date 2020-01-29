local utils = (import 'utils.libsonnet');

local hass = {
  automation: import 'automation.libsonnet',
  binary_sensor: import 'binary_sensor.libsonnet',
  climate: import 'climate.libsonnet',
  device_tracker: import 'device_tracker.libsonnet',
  homeassistant: import 'homeassistant.libsonnet',
  input_datetime: import 'input_datetime.libsonnet',
  input_number: import 'input_number.libsonnet',
  input_select: import 'input_select.libsonnet',
  input_text: import 'input_text.libsonnet',
  lovelace: import 'lovelace.libsonnet',
  media_player: import 'media_player.libsonnet',
  person: import 'person.libsonnet',
  script: import 'script.libsonnet',
  sensor: import 'sensor.libsonnet',
  switch: import 'switch.libsonnet',
};

local entity_domains = [
  'automation',
  'binary_sensor',
  'climate',
  'cover',
  'device_tracker',
  'input_datetime',
  'input_number',
  'input_select',
  'input_text',
  'media_player',
  'person',
  'script',
  'sensor',
  'switch',
];

{
  new(
    name='home-assistant',
    components={},
    entities={},
    dashboards={},
    log_level=null,
    monitoring=null,
    frontend=null,
    discovery=false,
    config=false,
    base_url=null,
    ssl_certificate=null,
    ssl_key=null
  ):: {
    local this = self,
    name:: name,
    base_url:: base_url,
    ssl_certificate:: ssl_certificate,
    ssl_key:: ssl_key,

    _components:: [
      (components[component]) + { id: component }
      for component in std.objectFields(components)
    ],

    _hue_gateways:: [
      (components[component]) + { id: component }
      for component in std.objectFields(components)
      if components[component].kind == 'hue'
    ],

    _aqara_gateways:: [
      (components[component]) + { id: component }
      for component in std.objectFields(components)
      if components[component].kind == 'xiaomi_aqara'
    ],

    _entities:: {
      [domain]: [
        (entities[group][domain][entity]) + {
          entity:: entity,
          group:: group,
        }
        for group in std.objectFields(entities)
        if std.objectHas(entities[group], domain)
        for entity in std.objectFields(entities[group][domain])
      ]
      for domain in entity_domains
    },

    _complete_entities:: {
      [domain]: [
        (entities[group][domain][entity]) + {
          entity: entity,
        }
        for group in std.objectFields(entities)
        if std.objectHas(entities[group], domain)
        for entity in std.objectFields(entities[group][domain])
      ]
      for domain in entity_domains
    },

    _custom_entities:: {
      [domain + '.' + entity.entity]: {
        [if std.objectHas(entity, 'assumed_state') then 'assumed_state']: entity.assumed_state,
        [if std.objectHas(entity, 'initial_state') then 'initial_state']: entity.initial_state,
        [if std.objectHas(entity, 'hidden') then 'hidden']: entity.hidden,
        [if std.objectHas(entity, 'device_class') then 'device_class']: entity.device_class,
        [if std.objectHas(entity, 'icon') then 'icon']: entity.icon,
        [if std.objectHas(entity, 'name') then 'friendly_name']: entity.name,
        [if std.objectHas(entity, 'unit') then 'unit_of_measurement']: entity.unit,
      }
      for domain in std.objectFields(this._complete_entities)
      for entity in this._complete_entities[domain]
      if std.objectHas(entity, 'entity')
    },

    _dashboards:: dashboards,

    _configuration::
      {
        homeassistant: hass.homeassistant.new(this, this._custom_entities),
        [if frontend != null then 'frontend']: {},
        [if frontend == 'lovelace' then 'lovelace']: {
          mode: 'yaml',
        },
        [if discovery then 'discovery']: {},
        [if log_level != null then 'logger']: {
          default: log_level,
          logs: {
            'homeassistant.components.camera': 'error',
            'homeassistant.components.automation': 'info',
            requests: 'error',
          },
        },
        [if this.base_url != null then 'http']: {
          base_url: this.base_url,
          [if this.ssl_certificate != null then 'ssl_certificate']: this.ssl_certificate,
          [if this.ssl_key != null then 'ssl_key']: this.ssl_key,
        },
        [if config then 'config']: {},
        [if monitoring != null then 'prometheus']: {
          namespace: 'hass',
        },

        [if std.length(this._entities.automation) > 0 then 'automation']:
          hass.automation.list(this._entities.automation),

        [if std.length(this._entities.binary_sensor) > 0 then 'binary_sensor']:
          hass.binary_sensor.list(this._entities.binary_sensor),

        [if std.length(this._entities.climate) > 0 then 'climate']:
          hass.climate.list(this._entities.climate),

        [if std.length(this._entities.climate) > 0 then 'cover']:
          hass.cover.list(this._entities.cover),

        [if std.length(this._entities.device_tracker) > 0 then 'device_tracker']:
          hass.device_tracker.list(this._entities.device_tracker),

        [if std.length(this._entities.input_datetime) > 0 then 'input_datetime']:
          hass.input_datetime.list(this._entities.input_datetime),

        [if std.length(this._entities.input_number) > 0 then 'input_number']:
          hass.input_number.list(this._entities.input_number),

        [if std.length(this._entities.input_select) > 0 then 'input_select']:
          hass.input_select.list(this._entities.input_select),

        [if std.length(this._entities.input_text) > 0 then 'input_text']:
          hass.input_text.list(this._entities.input_text),

        [if std.length(this._entities.media_player) > 0 then 'media_player']:
          hass.media_player.list(this._entities.media_player),

        [if std.length(this._entities.person) > 0 then 'person']:
          hass.person.list(this._entities.person),

        [if std.length(this._entities.script) > 0 then 'script']:
          hass.script.list(this._entities.script),

        [if std.length(this._entities.sensor) > 0 then 'sensor']:
          hass.sensor.list(this._entities.sensor),

        [if std.length(this._entities.switch) > 0 then 'switch']:
          hass.switch.list(this._entities.switch),
      } + {
        ['fastdotcom']: {
          scan_interval: {
            minutes: 30,
          },
        }
        for entity in this._entities.sensor
        if std.objectHas(entity, 'platform') && entity.platform == 'fastdotcom'
      } + {
        ['netatmo']: component + utils.hidden_component_fields
        for component in this._components
        if component.kind == 'netatmo'
      } + {
        ['nest']: {
          client_id: component.client_id,
          client_secret: component.client_secret,
        }
        for component in this._components
        if component.kind == 'nest'
      } + {
        ['sense']: {
          email: component.email,
          password: component.password,
        }
        for component in this._components
        if component.kind == 'sense'
      } + {
        ['homeconnect']: {
          client_id: component.client_id,
          client_secret: component.client_secret,
        }
        for component in this._components
        if component.kind == 'homeconnect'
      } + {
        ['sun']: {}
        for component in this._components
        if component.kind == 'sun'
      } + {
        ['map']: {}
        for component in this._components
        if component.kind == 'map'
      } + {
        [component.id]: {
          name: component.name,
          latitude: component.latitude,
          longitude: component.longitude,
          radius: component.radius,
          icon: component.icon,
        }
        for component in this._components
        if component.kind == 'zone'
      } + {
        [if std.length(this._aqara_gateways) > 0 then 'xiaomi_aqara']: {
          discovery_retry: 5,
          gateways: [
            {
              key: component.key,
            }
            for component in this._components
            if component.kind == 'xiaomi_aqara'
          ],
        },
      } + {
        [if std.length(this._hue_gateways) > 0 then 'hue']: {
          bridges: [
            {
              host: component.host,
              [if std.objectHas(component, 'allow_unreachable') then 'allow_unreachable']:
                component.allow_unreachable,
              [if std.objectHas(component, 'allow_hue_groups') then 'allow_hue_groups']:
                component.allow_hue_groups,
            }
            for component in this._components
            if component.kind == 'hue'
          ],
        },
      } + {
        ['mqtt']: {
          broker: component.host,
          port: component.port,
          [if std.objectHas(component, 'usename') then 'usename']: component.usename,
          [if std.objectHas(component, 'password') then 'password']: component.password,
          client_id: this.name,
          keepalive: 60,
          protocol: 3.1,
        }
        for component in this._components
        if component.kind == 'mqtt'
      },

    'configuration.yaml':
      std.manifestYamlDoc(this._configuration),

    [if frontend == 'lovelace' then 'ui-lovelace.yaml']:
      std.manifestYamlDoc(hass.lovelace.new(this)),

    [if std.length(utils.get_components(components, 'hue')) > 0 then 'phue.conf']:
      std.manifestJsonEx(
        {
          [component.host]: {
            username: component.username,
          }
          for component in this._components
          if component.kind == 'hue'
        }, '  '
      ),

    [if std.length(utils.get_components(components, 'braviatv')) > 0 then 'bravia.conf']:
      std.manifestJsonEx(
        {
          [component.host]: {
            host: component.host,
            mac: component.mac,
            pin: component.pin,
          }
          for component in this._components
          if component.kind == 'braviatv'
        }, '  '
      ),
  },
}
