require 'fileutils'
require 'xmlsimple'
require 'cgi'

class JUNITFormatter < XCPretty::Simple
  FILE_PATH = 'build/reports/errors.xml'.freeze

  def initialize(use_unicode, colorize)
    super
    @warnings = []
    @ld_warnings = []
    @compile_warnings = []
    @errors = []
    @compile_errors = []
    @file_missing_errors = []
    @undefined_symbols_errors = []
    @duplicate_symbols_errors = []
    @failures = {}
    @tests_summary_messages = []
  end

  def format_ld_warning(message)
    @ld_warnings << message
    write_to_file_if_needed
    super
  end

  def format_warning(message)
    @warnings << message
    write_to_file_if_needed
    super
  end

  def format_compile_warning(file_name, file_path, reason, line, cursor)
    @compile_warnings << {
      message: reason, 
      type: "WARNING", 
      "content" => "\nFile: #{file_name}\n"\
                   "Path: #{file_path}\n"\
                   "Line: #{line}\n"\
                   "Reason: #{reason}\n"\
                   "Cursor: #{cursor}\n"
    }
    write_to_file_if_needed
    super
  end

  def format_error(message)
    @errors << message
    write_to_file_if_needed
    super
  end

  def format_compile_error(file_name, file_path, reason, line, cursor)
    @compile_errors << {
      message: reason, 
      type: "ERROR", 
      "content" => "\nFile: #{file_name}\n"\
                   "Path: #{file_path}\n"\
                   "Line: #{line}\n"\
                   "Reason: #{reason}\n"\
                   "Cursor: #{cursor}\n"
    }
    write_to_file_if_needed
    super
  end

  def format_file_missing_error(reason, file_path)
    @file_missing_errors << {
      message: reason, 
      type: "ERROR", 
      "content" => "\nFile: #{file_path}\n"\
                   "Reason: #{reason}\n"
    }
    write_to_file_if_needed
    super
  end

  def format_undefined_symbols(message, symbol, reference)
    @undefined_symbols_errors = {
      message: message,
      type: "ERROR", 
      "content" => "Reference: #{reference}"\
      "Symbol: #{symbol}"
    }
    write_to_file_if_needed
    super
  end

  def format_duplicate_symbols(message, file_paths)
    @duplicate_symbols_errors = {
      message: message,
      type: "ERROR", 
      "content" => "\nMessage: #{message}\n"\
      "Paths: #{file_paths}\n"
    }
    write_to_file_if_needed
    super
  end

  def format_test_summary(message, failures_per_suite)
    @failures = failures_per_suite.map { |key, value|
      {
        name: key,
        failure: value.map { |failure| 
          {
            message: CGI.escapeHTML(failure[:reason]), 
            type: "ERROR", 
            "content" => "\nFile: #{failure[:file_path]}\n"\
                         "Reason: #{failure[:reason]}\n"\
                         "Test Case: #{failure[:test_case]}\n"
          }
        }
      } 
    }

    @tests_summary_messages << message

    puts "😂: #{@failures}"
    puts "😂: #{@tests_summary_messages}"

    write_to_file_if_needed
    super
  end

  def finish
    write_to_file
    super
  end

  def combined_compile_errors 
    [ @errors, @compile_errors, @file_missing_errors, 
      @undefined_symbols_errors, @duplicate_symbols_errors ].flatten.compact.delete_if &:empty?
    end

    def combined_compile_warnings 
      [@warnings, @ld_warnings, @compile_warnings].flatten.compact.delete_if &:empty?
    end

    def combined_test_failures
      [@failures].flatten.compact.delete_if &:empty?
    end

    def junit_output
      {
        testsuites: {
          name: "xcode_build", 
          testsuite: [
            {
              name: "compile", 
              testcase: [
                {
                  name: "failures", 
                  failure: combined_compile_warnings
                }, 
                {
                  name: "errors", 
                  error: combined_compile_errors
                }
              ]
            }, 
            {
              name: "test", 
              testcase: combined_test_failures
            }
          ]
        }
      }
    end

    def write_to_file_if_needed
      write_to_file unless XCPretty::Formatter.method_defined? :finish
    end

    def write_to_file
      file_name = ENV['XCPRETTY_JUNIT_FILE_OUTPUT'] || FILE_PATH
      dirname = File.dirname(file_name)
      FileUtils.mkdir_p dirname

      File.open(file_name, 'w') do |io|
        io.write(XmlSimple.xml_out(junit_output, {keeproot: true, noescape: true}))
      end
    end
  end

  JUNITFormatter
