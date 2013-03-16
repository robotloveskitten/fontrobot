require 'spec_helper'

describe Fontrobot do
  let(:input_dir) { 'spec/fixtures/vectors' }
  let(:output_dir) { 'tmp' }
  let(:fake_file) { output_dir + '/non-vector.txt' }

  context 'when ouput_dir already contains files' do
    # Compile, add non-fontrobot file, change input vectors, recompile
    before(:all) do
      # originals
      Fontrobot.compile(input_dir, '-o', output_dir, '-n', 'Original Font')
      FileUtils.touch(fake_file, :verbose => true)
      @original_fonts = Dir[output_dir + '/fontrobot-*.{woff,eot,ttf,svg}']
      @original_css = File.read(output_dir + '/fontrobot.css')

      FileUtils.mv(input_dir + '/C.svg', input_dir + '/E.svg', :verbose => true)
      Fontrobot.compile(input_dir, '-o', output_dir)
    end

    after(:all) do
      cleanup(output_dir)
      FileUtils.mv(input_dir + '/E.svg', input_dir + '/C.svg', :verbose => true)
    end

    it 'should delete previous fontrobot generated files' do
      new_files = Dir[output_dir + '/*']
      @original_fonts.each do |original|
        new_files.should_not include(original)
      end
    end

    it 'should generate different css' do
      new_css = File.read(output_dir + '/fontrobot.css')
      new_css.should_not equal(@original_css)
    end
  end
end
