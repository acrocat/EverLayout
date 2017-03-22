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

EverLayout can be instantiated with a configuration argument which specifies which parsers to
use.

```
self.layout = EverLayout(layoutData: layoutData, parserConfiguration: EverLayoutConfiguration(
            indexParser: LayoutIndexXMLParser(),
            viewParser: LayoutViewXMLParser(),
            constraintParser: LayoutConstraintXMLParser(),
            propertyParser: LayoutPropertyXMLParser()))
self.layout.buildLayout(onView: self.view, viewEnvironment: self)

```

## Notes

For general usage tips on writing a parser, check out the JSON parsers that are included:

* `LayoutIndexJSONParser`
* `LayoutViewJSONParser`
* `LayoutConstraintsJSONParser`
* `LayoutConstraintsJSONComprehensiveParser`
* `LayoutPropertiesJSONParser`
* `LayoutTemplatesJSONParser`
