require './test/helper'

class ContentTypeDetectorTest < Test::Unit::TestCase
  context 'given a name' do
    should 'return a content type based on that name' do
      @filename = "/path/to/something.jpg"
      assert_equal "image/jpeg", Paperclip::ContentTypeDetector.new(@filename).detect
    end

    should 'return a content type based on the content of the file' do
      tempfile = Tempfile.new("something")
      tempfile.write("This is a file.")
      tempfile.rewind

      assert_equal "text/plain", Paperclip::ContentTypeDetector.new(tempfile.path).detect
    end

    should 'return a sensible default if something goes wrong' do
      @filename = "/path/to/something"
      assert_equal "application/octet-stream", Paperclip::ContentTypeDetector.new(@filename).detect
    end

    should 'let errors raise if something blows up' do
      Paperclip.stubs(:run).raises(Cocaine::CommandLineError.new)
      @filename = "/path/to/something"
      assert_raises(Cocaine::CommandLineError) do
        Paperclip::ContentTypeDetector.new(@filename).detect
      end
    end
  end
end