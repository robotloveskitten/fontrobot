require 'spec_helper'

describe Fontrobot::Generator do
  let(:input_dir) { 'spec/fixtures/vectors' }
  let(:output_dir) { 'tmp' }

  context 'normally' do
    before(:all) { Fontrobot::Generator.start([input_dir, '-o', output_dir]) }
    after(:all) { cleanup(output_dir) }

    it 'should create webfonts' do
      exts = %w( .woff .eot .ttf .svg )
      files = Dir[output_dir + '/*']
      files.map! { |file| File.extname(file) }

      exts.each { |ext| files.should include(ext) }
    end

    it 'should print font-face declarations in fontrobot.css' do
      stylesheet = File.read(output_dir + '/fontrobot.css')
      files = Dir[output_dir + '/*.{woff,eot,ttf,svg}']

      files.each do |file|
        stylesheet.should include(File.basename(file))
      end
    end

    it 'should print icon-* CSS classes in fontrobot.css' do
      stylesheet = File.read(output_dir + '/fontrobot.css')
      icon_names = Dir[input_dir + '/*'].map { |file| File.basename(file)[0..-5].gsub(/\W/, '-').downcase }

      icon_names.each do |name|
        stylesheet.should include('.icon-' + name)
      end
    end
  end

  context 'when input_dir does not exist' do
    let(:fake_input_dir) { 'does/not/exist' }

    it 'should raise an error' do
      results = capture(:stderr) { Fontrobot::Generator.start([fake_input_dir, '-o', output_dir]) }
      results.should =~ /doesn't exist or isn't a directory/
    end
  end

  context 'when input_dir does not contain vectors' do
    let(:empty_input_dir) { 'spec/fixtures/empty' }

    it 'should raise an error' do
      results = capture(:stderr) { Fontrobot::Generator.start([empty_input_dir, output_dir]) }
      results.should =~ /doesn't contain any vectors/
    end
  end

  context 'when flags are passed' do
    it 'should save output files with a custom name' do
      Fontrobot::Generator.start([input_dir, '-o', output_dir, '-n', 'customname'])
      file = Dir[File.join(output_dir, 'customname-*.ttf')].first
      File.exists?(file).should be_true
      cleanup(output_dir)
    end

    it 'should exclude the filename hash' do
      Fontrobot::Generator.start([input_dir, '-o', output_dir, '--nohash'])
      file = File.join(output_dir, 'fontrobot.ttf')
      File.exists?(file).should be_true
      cleanup(output_dir)
    end

    it 'should output an html test file' do
      Fontrobot::Generator.start([input_dir, '-o', output_dir, '--html'])
      file = File.join(output_dir, 'test.html')
      File.exists?(file).should be_true
      cleanup(output_dir)
    end

    it 'should output .scss files' do
      Fontrobot::Generator.start([input_dir, '-o', output_dir, '--scss'])
      file = File.join(output_dir, 'fontrobot.scss')
      File.exists?(file).should be_true
      cleanup(output_dir)
    end

    it 'should reorder the font sources in fontrobot.css' do
      font_order = 'eot,woff,ttf,svg'
      Fontrobot::Generator.start([input_dir, '-o', output_dir, '-r', font_order])
      stylesheet = File.read(output_dir + '/fontrobot.css')
      fontface = stylesheet.match(/@font-face[^}]+/)
      fonts = fontface[0].scan(/fontrobot-[a-z0-9]+.([a-z]+)/).flatten.join(',')
      fonts.should == font_order
    end

    it 'should set a font path in fontrobot.css' do
      Fontrobot::Generator.start([input_dir, '-o', output_dir, '-f', 'wiggly'])
      stylesheet = File.read(output_dir + '/fontrobot.css')
      stylesheet.should include('wiggly')
    end

    it 'should include a data uri in fontrobot.css' do
      Fontrobot::Generator.start([input_dir, '-o', output_dir, '-i', 'woff'])
      stylesheet = File.read(output_dir + '/fontrobot.css')
      stylesheet.should include('url(data:')
    end

  end
end
