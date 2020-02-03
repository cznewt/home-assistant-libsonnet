# Home-assistant-libsonnet, a Jsonnet library for generating Home Assistant configurations

*NOTE: This project is in alpha stage. Everything may change significantly in
the following updates.*

Home-assistant-libsonnet provides a simple way of defining Home-assistant
configuration. It leverages the data templating language [Jsonnet][jsonnet]. It
enables you to write reusable components that you can use and reuse for multiple
configurations.

## Getting started

### Prerequisites

Home-assistant-libsonnet requires Jsonnet.

#### Linux

You must build the binary. For details, [see the GitHub repository][jsonnetgh].

#### Mac OS X

Jsonnet is available in Homebrew. If you do not have Homebrew installed,
[install it][brew].

Then run:

```
brew install jsonnet
```

### Install home-assistant-libsonnet

Clone this git repository:

```
git clone https://github.com/cznewt/home-assistant-libsonnet.git
```

Then import the home-assistant-libsonnet in your jsonnet code:

```
local hass = import 'home-assistant-libsonnet/hass.libsonnet';
```

To be able to find the Home-assistant-libsonnet library, you must pass the root of the git
repository to Home-assistant-libsonnet using the `-J` option:

```
jsonnet -J <path> config.jsonnet
```

As you build your own mixins/configs, you should add additional `-J` paths.

## Examples

Simple Configuration example:

```jsonnet
local config = import 'home-assistant-libsonnet/config.libsonnet';

local parameters = {
  id: 'presence_nmap',
  name: 'NMAP Tracker',
  hosts: '10.0.0.*',
};

config.new(
  entities={
    presence_nmap: {
      device_tracker: {
        ['%(id)s_tracker' % parameters]: {
          home_interval: 5,
          hosts: parameters.hosts,
          interval_seconds: 30,
          platform: 'nmap_tracker',
          scan_options: ' --privileged -sP ',
        },
      },
    },
  },
)
```

Simple Phillips Hue config using mixins:

```jsonnet
local config = import 'home-assistant-libsonnet/config.libsonnet';

local mixins = (import 'home-assistant-/light-phillips-hue-mixin/mixin.libsonnet') +
               (import 'home-assistant-/gateway-mixin/mixin.libsonnet');

local gateway = {
  host: '<<hostname/ip>>',
  username: '<<username>>',
};

local parameters = {
  id: 'light_phillips_hue_color',
  name: 'Lights',
  hue_group: 'livingroom',
  hue_lights: [
    'light.livingroom',
  ],
  scenes: [
    'Bright',
    'Relax',
    'Energize',
  ],
  initial_scene: 'Relax',
};

config.new(
  components={
    phillips_hue_gateway:
      mixins.phillips_hue_gateway_component(gateway),
  },
  entities={
    light_phillips_hue_color:
      mixins.light_phillips_hue_color_entities(parameters),
  },
)
```

Find more examples in the [mixins](https://github.com/cznewt/home-assistant-mixins) repository.

[brew]:https://brew.sh/
[jsonnet]:http://jsonnet.org/
[jsonnetgh]:https://github.com/google/jsonnet