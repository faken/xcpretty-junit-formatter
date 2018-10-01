require 'spec_helper'
require 'fileutils'
require 'tmpdir'

describe 'JUNITFormatter' do
  it 'formats raw_kiwi_compilation_fail' do
    verify_file('raw_kiwi_compilation_fail')
  end

  it 'formats raw_kiwi_fail' do
    verify_file('raw_kiwi_fail')
  end

  it 'formats raw_specta_fail' do
    verify_file('raw_specta_fail')
  end

  it 'formats xcodebuild' do
    verify_file('xcodebuild')
  end

  it 'formats xcodebuild_multitest' do
    verify_file('xcodebuild_multitest')
  end

  def verify_file(file)
    output = nil
    Dir.mktmpdir do |dir|
      FileUtils.cp("spec/fixtures/#{file}.log", dir)
      Dir.chdir(dir) do
        %x(cat #{file}.log | XCPRETTY_JUNIT_FILE_OUTPUT=result.xml bundle exec xcpretty -f `xcpretty-junit-formatter`)
        output = XmlSimple.xml_in(File.read('result.xml'))
      end
    end
    expect(output).to eq xml_fixture(file)
  end
end
