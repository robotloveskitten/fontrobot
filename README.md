FontRobot v0.1.1
==========

**Generate custom icon webfonts from the comfort of the command line.**

This is a fork of Fontcustom. I needed a quick fork to work out the kinks using this gem in a large-scale production Rails environment. I'm testing it live every day. :) I hope to merge my changes upstream to Fontcustom soon (Just FYI).

FontRobot is primarily designed to add more control over how the @fontface declaration is created. See command-line options below for more details.

Fontrobot allows you specify the font order in @font-face, to inline font(s) as a data-uri, and creates an IE-compatible @font-face declaration. 

Data-uri fonts are nice because they circumvent some browser's origin policies and they load fast. For best performance, make sure your server gzips all served assets.

[Original Fontcustom documentation](http://fontcustom.github.com/fontcustom/)


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
--inline, -i      => Specify fonts to include as data-uri's in @font-face. Default: none. Format: "ttf,svg" One is enough though.

--nohash          => (boolean) Disable filename hashes. Default: false
--debug           => (boolean) Display debug messages. Default: false
--html            => (boolean) Generate html page with icons. Default: false
--scss            => (boolean) Output .scss files. Default: false
```

Need help?

```sh
fontrobot --help
```
