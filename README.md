# XCPretty JUnit Formatter

[![License](http://img.shields.io/badge/license-MIT-green.svg?style=flat)](LICENSE.txt)
[![Gem](https://img.shields.io/gem/v/xcpretty-junit-formatter.svg?style=flat)](http://rubygems.org/gems/xcpretty-junit-formatter)
[![Build Status](https://travis-ci.org/marcelofabri/xcpretty-json-formatter.svg?branch=master)](https://travis-ci.org/marcelofabri/xcpretty-json-formatter)

Custom formatter for [xcpretty](https://github.com/supermarin/xcpretty) that saves on a XML (JUnit) file all the errors, warnings and test failures, so you can process them easily later.

## Installation

This formatter is distributed via RubyGems, and depends on a version of `xcpretty` >= 0.0.7 (when custom formatters were introduced). Run:

    gem install xcpretty-junit-formatter

## Usage

Specify `xcpretty-junit-formatter` as a custom formatter to `xcpretty`:

```bash
#!/bin/bash

xcodebuild | xcpretty -f `xcpretty-junit-formatter`
```

By default, `xcpretty-junit-formatter` writes the result in `build/reports/errors.xml`, but you can change that with an environment variable:

```bash
#!/bin/bash

xcodebuild | XCPRETTY_JUNIT_FILE_OUTPUT=result.xml xcpretty -f `xcpretty-junit-formatter`
```

## Output format

You can check some example JUnit xml files in the [fixtures folder](spec/fixtures).

## Thanks

* [Marin Usalj](http://github.com/supermarin) and [Delisa Mason](http://github.com/kattrali) for creating [xcpretty](https://github.com/supermarin/xcpretty).
* [Delisa Mason](http://github.com/kattrali) for creating [xcpretty-travis-formatter](https://github.com/kattrali/xcpretty-travis-formatter), which I used as a guide.

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/faken/xcpretty-junit-formatter.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

