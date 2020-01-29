{
  get_components(components, kind):: [
    (components[component]) + { id: component }
    for component in std.objectFields(components)
    if components[component].kind == kind
  ],

  hidden_fields: {
    area:: null,
    entity:: null,
    device_class:: null,
    icon:: null,
    name:: null,
    unit:: null,
  },

  hidden_component_fields: {
    id:: null,
    kind:: null,
  },
}
