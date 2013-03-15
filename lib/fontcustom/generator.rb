require 'json'
require 'thor/group'
require 'base64'

module Fontcustom
  class Generator < Thor::Group
    include Thor::Actions

    desc 'Generates webfonts from given directory of vectors.'

    argument :input, :type => :string
    class_option :output, :aliases => '-o'
    class_option :name, :aliases => '-n'
    class_option :font_path, :aliases => '-f'

    class_option :order,      :aliases => '-r' # 'Specify font order in css @font-face. Default: "eot,ttf,woff,svg"'
    class_option :inline,     :aliases => '-i' # 'Inline font as data-uri in @font-face. Default: none. Format: "eot,ttf,woff,svg"'
    class_option :extension,  :aliases => '-e' # 'Specify file extension for css output. Default: "css".'

    class_option :nohash, :type => :boolean, :default => false
    class_option :debug, :type => :boolean, :default => false
    class_option :html, :type => :boolean, :default => false


    def self.source_root
      File.dirname(__FILE__)
    end

    def verify_fontforge
      if `which fontforge` == ''
        raise Thor::Error, 'Please install fontforge first.'
      end
    end

    def verify_input_dir
      if ! File.directory?(input)
        raise Thor::Error, "#{input} doesn't exist or isn't a directory."
      elsif Dir[File.join(input, '*.{svg,eps}')].empty?
        raise Thor::Error, "#{input} doesn't contain any vectors (*.svg or *.eps files)."
      end
    end

    def verify_or_create_output_dir
      @output = options.output.nil? ? File.join(File.dirname(input), 'fontcustom') : options.output
      empty_directory(@output) unless File.directory?(@output)
    end

    def normalize_name
      @name = if options.name
        options.name.gsub(/\W/, '-').downcase
      else
        'fontcustom'
      end
    end

    def cleanup_output_dir
      css = File.join(@output, 'fontcustom.css')
      css_ie7   = File.join(@output, 'fontcustom-ie7.css')
      test_html = File.join(@output, 'test.html')
      old_name = if File.exists? css
                   line = IO.readlines(css)[5]                           # font-family: "Example Font";
                   line.scan(/".+"/)[0][1..-2].gsub(/\W/, '-').downcase  # => 'example-font'
                 else
                   'fontcustom'
                 end

      old_files = Dir[File.join(@output, old_name + '-*.{woff,ttf,eot,svg}')]
      old_files << css if File.exists?(css)
      old_files << css_ie7 if File.exists?(css_ie7)
      old_files << test_html if File.exists?(test_html)
      old_files.each {|file| remove_file file }
    end


    def generate
      gem_file_path = File.expand_path(File.join(File.dirname(__FILE__)))
      name = options.name ? ' --name ' + @name : ''
      nohash = options.nohash ? ' --nohash' : ''

      # suppress fontforge message
      # TODO get font name and classes from script (without showing fontforge message)
      cmd = "fontforge -script #{gem_file_path}/scripts/generate.py #{input} #{@output + name + nohash}"
      unless options.debug
        cmd += " > /dev/null 2>&1"
      end
      `#{cmd}`
    end


    def show_paths
      file = Dir[File.join(@output, @name + '*.ttf')].first
      @path = file.chomp('.ttf')

      ['woff','ttf','eot','svg'].each do |type|
        say_status(:create, @path + '.' + type)
      end
    end


    def fontface_sources
      if(!options.font_path.nil?)
        font_path = (options.font_path) ? options.font_path : ''
        @path = File.join(font_path, File.basename(@path))
      else
        @path = File.basename(@path)
      end

      @fontface = {
        :eot  => "url(\"#{@path}.eot?#iefix\") format(\"embedded-opentype\")",
        :woff => "url(\"#{@path}.woff\") format(\"woff\")",
        :ttf  => "url(\"#{@path}.ttf\") format(\"truetype\")",
        :svg  => "url(\"#{@path}.svg##{@name}\") format(\"svg\")"
      }

      # reorder the fontface hash
      order = (options.order) ? options.order.split(",") : ['eot','ttf','woff','svg']
      inline = (options.inline) ? options.inline.split(",") : []
      reorder = {}
      longtype = {
        'woff' => 'woff',
        'ttf'   => 'truetype',
        'eot' => 'embedded-opentype',
        'svg' => 'svg'
      }

      # say_status(:create, 'building fontface: ' + options.inspect)

      order.each do |type|
        if(inline.include?(type))
          fontpath = File.expand_path(File.join(@output, File.basename(@path)+"."+type))
          contents = File.read(fontpath)
          encoded_contents = Base64.encode64(contents).gsub(/\n/, '') # remove newlines
          fontstring = "url(data:application/x-font-#{type};charset=utf-8;base64," + encoded_contents +") format('#{longtype[type]}')"
        else
          fontstring = @fontface[type.to_sym]
        end
        reorder[type.to_sym] = fontstring
      end

      @fonturls = reorder.map{|k,v| v }.join(",\n");
    end


    def create_stylesheet
      say_status(:create, 'creating stylesheet')

      files = Dir[File.join(input, '*.{svg,eps}')]
      @classes = files.map {|file| File.basename(file)[0..-5].gsub(/\W/, '-').downcase }

      template('templates/fontcustom.css', File.join(@output, 'fontcustom.css'))
      template('templates/fontcustom-ie7.css', File.join(@output, 'fontcustom-ie7.css'))
      template('templates/test.html', File.join(@output, 'test.html')) if options.html
    end
  end
end
