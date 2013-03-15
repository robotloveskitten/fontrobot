require 'thor'
require 'fontcustom'

module Fontcustom
  class CLI < Thor
    # duplicated from Fontcustom::Generator so as to also appear under `fontcustom help` command
    class_option :output,     :aliases => '-o', :desc => 'Specify an output directory. Default: $DIR/fontcustom'
    class_option :name,       :aliases => '-n', :desc => 'Specify a font name. This will be used in the generated fonts and CSS. Default: fontcustom'
    class_option :font_path,  :aliases => '-f', :desc => 'Specify a path for fonts in css @font-face declaration. Default: none'

    class_option :order,      :aliases => '-r', :desc => 'Specify font order in css @font-face. Default: "eot,ttf,woff,svg"'
    class_option :inline,     :aliases => '-i', :desc => 'Inline font as data-uri in @font-face. Default: none. Format: "eot,ttf,woff,svg"'

    class_option :nohash,     :type => :boolean, :default => false, :desc => 'Disable filename hashes. Default: false'
    class_option :debug,      :type => :boolean, :default => false, :desc => 'Display debug messages. Default: false'
    class_option :html,       :type => :boolean, :default => false, :desc => 'Generate html page with icons'
    class_option :scss,       :type => :boolean, :default => false, :desc => 'Output .scss files'

    desc 'compile DIR [options]', 'Generates webfonts and CSS from *.svg and *.eps files in DIR.'
    def compile(*args)
      # workaround to pass arguments from one Thor class to another
      ARGV.shift
      Fontcustom.compile(*ARGV)
    end

    desc 'watch DIR [options]', 'Watches DIR for changes and regenerates webfonts and CSS automatically. Ctrl + C to stop.'
    def watch(*args)
      ARGV.shift
      Fontcustom.watch(*ARGV)
    end
  end
end
