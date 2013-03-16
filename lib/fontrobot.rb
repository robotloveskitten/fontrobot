require 'fontrobot/version'
require 'fontrobot/generator'
require 'fontrobot/watcher'

module Fontrobot
  # Usage:
  # Fontrobot.compile 'path/to/vectors', '-o', 'path/to/output'
  def compile(*args)
    Fontrobot::Generator.start(args) # as array
  end

  def watch(*args)
    Fontrobot::Watcher.watch(*args)
  end

  def stop
    Fontrobot::Watcher.stop
  end

  module_function :compile, :watch, :stop
end
