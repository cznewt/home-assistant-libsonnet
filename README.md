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

Simple Phillips Hue config:

```jsonnet
local config = import 'home-assistant-libsonnet/config.libsonnet';


local config = import '../hassonnet/config.libsonnet';
local mixins = (import '../mixins/light-phillips-hue-mixin/mixin.libsonnet') +
               (import '../mixins/gateway-mixin/mixin.libsonnet');

local parameters = {
  id: 'light_phillips_hue_color',
  name: 'Lights',
  hue_group: 'livingroom',
  hue_lights: [
    'light.livingroom',
    'light.livingroom_wall_1',
    'light.livingroom_wall_2',
  ],
  scenes: [
    'Bright',
    'Relax',

    'Energize',
    'Spring blossom',
    'Tropical twilight',
  ],
  initial_scene: 'Relax',
  initial_brightness: 128,
};

config.new(
  name='Location Name',
  components={
    phillips_hue_gateway:
      mixins.phillips_hue_gateway_component({
        host: '<<hostname/ip>>',
        username: '<<username>>',
      }),
  },
  entities={
    light_phillips_hue_color:
      mixins.light_phillips_hue_color_entities(parameters),
  },
)


local mixins = (import 'mixins/light_hue/mixin.libsonnet');

config.new(
  name='test',
  components={
    phillips_hue_bridge: {
      ip: '10.0.0.1',
    },
  },
  entities={
    livingroom_room_lights: mixins.light_hue_color_entities({
      name: 'livingroom_lights',
      hue_group: 'livingroom',
      light_scenes: [
        'Bright',
        'Relax',
        'Arctic aurora',
        'Savanna sunset',
        'Nightlight',
        'Dimmed',
        'Read',
        'Concentrate',
        'Energize',
        'Spring blossom',
        'Tropical twilight',
      ],
      initial_scene: 'Relax',
      initial_brightness: 128,
    }),
  },
  dashboards={
    livingroom_room_lights_control: mixins.light_hue_color_control_card({
      name: 'livingroom_lights',
      hue_group: 'livingroom',
    }),
  },
)
```

Find more examples in the [examples](examples/) directory.

[brew]:https://brew.sh/
[jsonnet]:http://jsonnet.org/
[jsonnetgh]:https://github.com/google/jsonnet