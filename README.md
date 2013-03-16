FontRobot v0.1
==========

**Generate custom icon webfonts from the comfort of the command line.**

This is a fork of Fontcustom, required so I could make changes and update the gem in a timely fashion. FontRobot extends Fontcustom, adding more control over how the @fontface declaration is created. See command-line options below for more details.

[Fontcustom documentation](http://fontcustom.github.com/fontcustom/)


Installation
------------

```sh
# Requires FontForge
brew install fontforge ttfautohint
gem install fontrobot
```


Usage
-----

```sh
fontrobot compile path/to/vectors  # Compile icons and css to path/to/fontrobot/*
fontrobot watch path/to/vectors    # Watch for changes
```

**Note:** the **ENTIRE** contents of the output directory (default '/fontrobot') are **DELETED** when regenerating the font. So, don't put anything else in there.


Command-line options
-----

```sh
--output, -o      => Specify an output directory. Default: $DIR/fontrobot
--name, -n        => Specify a font name. This will be used in the generated fonts and CSS. Default: fontrobot
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
fontrobot --help
```
