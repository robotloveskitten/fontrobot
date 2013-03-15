FontCustom v0.1.4
==========

**Generate custom icon webfonts from the comfort of the command line.**

[Full documentation](http://fontcustom.github.com/fontcustom/)<br/>
[Feedback and issues](https://github.com/FontCustom/fontcustom/issues)


Installation
------------

```sh
# Requires FontForge
brew install fontforge ttfautohint
gem install fontcustom
```


Usage
-----

```sh
fontcustom compile path/to/vectors  # Compile icons and css to path/to/fontcustom/*
fontcustom watch path/to/vectors    # Watch for changes
```

Note: the contents of the output directory (default '/fontcustom') are deleted when regenerating the font. 


Command-line options
-----

```sh
--output, -o      => Specify an output directory. Default: $DIR/fontcustom
--name, -n        => Specify a font name. This will be used in the generated fonts and CSS. Default: fontcustom
--font_path, -f   => Specify a path for fonts in css @font-face declaration. Default: none

--order, -r       => Specify font order in css @font-face. Default: "eot,ttf,woff,svg"
--inline, -i      => Include specified font fomats as data-uri in @font-face. Default: none. Format: "eot,ttf,woff,svg"

--nohash          => (boolean) Disable filename hashes. Default: false
--debug           => (boolean) Display debug messages. Default: false
--html            => (boolean) Generate html page with icons. Default: false
--scss            => (boolean) Output .scss files. Default: false
```

Need help?

```sh
fontcustom --help
```
