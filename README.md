FontRobot v0.1.7
==========

**Generate custom icon webfonts from the comfort of the command line.**

This is a fork of Fontcustom. I needed a quick fork to work out the kinks using this gem in a large-scale production Rails environment. FontRobot is primarily designed to add more control over how the @fontface declaration is created. See command-line options below for more details.

Fontrobot allows you to:

* Specify the font order in @font-face
* Inline font(s) as a data-uri
* Create an IE-compatible @font-face declaration
* output css files with .scss extension for importing to Sass projects

Including fonts as data-uris is nice because it avoids Firefox's same-origin policy (CORS) and they load fast. For best performance, make sure your server gzips all served assets.

**NOTE:** After upgrading, rename or delete your current output directory (or all generated font/css files), as Fontrobot won't be able to clean the directory using the old css template.

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
