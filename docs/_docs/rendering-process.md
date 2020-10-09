---
---

For any Jekyll site, a *build session* consists of discrete phases in the following order --- *setting up plugins,
reading source files, running generators, rendering templates*, and finally *writing files to disk*.

While the phases above are self-explanatory, the one phase that warrants dissection is *the rendering phase*.

The rendering phase is further divisible into three optional stages. Every file rendered, passes through one or more of
these stages as determined by the file's content string, front matter and extension. The stages are akin to an assembly
line, with the *output* from a stage being the *input* for the succeeding stage:
- **Interpreting Liquid expressions in the file**<br/>
  This stage evaluates Liquid expressions in the current file. By default, the interpretation is *shallow* --- in that
  any Liquid expression in resulting output is not further interpreted. Moreover, any Liquid expression in the file's
  front matter is left untouched.
- **Unleashing the converters**<br/>
  This stage invokes the converter mapped to the current file's extension and converts the input string. This is when
  Markdown gets converted into HTML and Sass / Scss into CSS or CoffeeScript into JavaScript, etc, etc. Since this stage
  is determined by the file's extension, Markdown or Sass inside a `.html` file will remain untouched.
- **Populating the layouts**<br/>
  By this stage, *the source file* is considered rendered and it will not be revisited. However, based on the file's
  extension and consequently based on the front matter, it is determined whether to take the *output* string from
  the preceding stage and place into layouts or not. Whereas output from Sass files or CoffeeScript files are *never*
  placed into a layout, regular text output can go either ways based on whether a layout has been assigned via the front
  matter.<br/><br/>
  Placement into layouts work similar to how Russian dolls encase the smaller ones within itself or how an oyster
  generates a pearl --- the converted output from the preceding stage forms the core and layout(s) are successively
  *rendered* separately onto the core.
