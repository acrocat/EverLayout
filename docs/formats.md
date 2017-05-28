# Formats

In the event that you don't want your layouts written in JSON, or that you wish
to create your own layout format, you can create custom parsers for EverLayout by 
conforming to a few protocols.

## Protocols

* `LayoutIndexParser`
* `LayoutViewParser`
* `LayoutConstraintParser`
* `LayoutPropertyParser`
* `LayoutTemplateParser`

## Using these parsers

The parsing of a layout always starts with its index, or the `LayoutIndexParser`.
When a parser returns a data model, it is responsible for ensuring that the model has
access to its own appropriate parser.

To use your own parsers, you can pass an `LayoutIndexParser` when instantiating 
EverLayout.

```
	self.layout = EverLayout(layoutData: data , indexParser: myYamlIndexParser)
```

## Notes

For general usage tips on writing a parser, check out the JSON parsers that are included:

* `LayoutIndexJSONParser`
* `LayoutViewJSONParser`
* `LayoutConstraintsJSONParser`
* `LayoutConstraintsJSONComprehensiveParser`
* `LayoutPropertiesJSONParser`
* `LayoutTemplatesJSONParser`
