# This is taken from rake repo.

require './helper'
require '../mrblib/shellwords'
require '../mrblib/main'

class FakeStdout
  def initialize
    @log = []
  end

  attr_accessor :log

  def puts msg
    @log << msg
  end
end

FileUtilsSimple::Delegator.stdout = FakeStdout.new

class TestFileUtilsSimple < $testunit_class

  def setup
    teardown
    Dir.mkdir $tmpdir
    Dir.chdir $tmpdir
  end

  def teardown
    Dir.chdir __dir__
    `rm -rf #{$tmpdir}`
  end

  def test_methods_list
    m = [
         :pwd,
         :cd,
         :touch,
        ]
    assert_equal m.sort, FileUtilsSimple.singleton_methods.sort
    assert_equal m.sort, FileUtilsSimple::DryRun.singleton_methods.sort
  end

  def test_pwd
    assert_equal __dir__, File.dirname(FileUtilsSimple::DryRun.pwd)
    assert_equal "pwd ", FileUtilsSimple::Delegator.stdout.log.pop

    assert_equal __dir__, File.dirname(FileUtilsSimple.pwd)
    assert_equal nil, FileUtilsSimple::Delegator.stdout.log.pop

    assert_equal __dir__, File.dirname(FileUtilsSimple.pwd(verbose: true))
    assert_equal "pwd ", FileUtilsSimple::Delegator.stdout.log.pop
  end

  def test_cd
    FileUtilsSimple.cd '/' do
      assert_equal '/', Dir.pwd
    end
    assert_equal __dir__, File.dirname(Dir.pwd)
  end

end

MTest::Unit.new.run if mruby?
