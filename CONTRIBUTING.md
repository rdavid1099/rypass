# Contributing

Thank you for your interest in contributing! We welcome developers of all skill levels to contribute to RyPass and will provide issues for those new to open-source and veterans alike. All tasks that we are looking to complete can be found in the [Issues](https://github.com/rdavid1099/rypass/issues) section. If you find a bug or would like to implement new functionality, please feel free to contact the owner, [rdavid1099@gmail.com](mailto:rdavid1099@gmail.com).

## Installation

- Fork and clone RyPass to your local machine, use [this guide](https://help.github.com/articles/fork-a-repo/) if you don't know how to do that.
- Set the upstream remote so you can keep your copy of RyPass synced with the original. To do that go to your terminal and `cd` into your cloned RyPass directory. Then user one of the following commands:

   If you have ssh set up with Git
   ```
   $ git remote add upstream git@github.com:rdavid1099/rypass.git
   ```
   Otherwise
   ```
   $ git remote add upstream https://github.com/rdavid1099/rypass.git
   ```

- From the root directory run `bundle install` to install all gem dependencies.
- Run `./config/seed.sh` to setup and seed your test environment.
- Run `rake test:rypass` to launch the test environment. The task will output `$rypass`, just enter any of the flags you want to test as if you were running `rypass` from the command line. In the test environment, all FileIO functionality will be handled in the `tmp/` directory in the root of the project.
- If you would like to install the application on your computer to test production, simply run `./config/install.sh` and run `rypass` from the terminal. `rypass uninstall` will remove the program from your computer.

## Code Style

While we encourage creativity and "clever" code, your implementation must follow basic Ruby standards and practices. This includes:

- Write readable and succinct code, and use standard functions in Ruby to the best of your knowledge.
- Blank lines should contain no spaces, and there should be no additional white space following the end of a line of code.
- Follow the [DRY](https://en.wikipedia.org/wiki/Don%27t_repeat_yourself) principle.
- Have fun!

## Testing

Tests are imperative to creating a functional and success program. We follow test driven development, and writing test cases should be done before any lines of code are written. Our test suite uses [Minitest](http://ruby-doc.org/stdlib-2.0.0/libdoc/minitest/rdoc/MiniTest.html) and should follow basic Minitest formatting and style. All features/ bugs must include coinciding tests to confirm their functionality, including sad cases.

### Writing Tests

Before creating a new test method or file, be sure to review `./test/test_helper.rb`. A lot of base logic (including requiring necessary files) is located in that file.

If you are writing a test that affects or is integrated with the FileIO functionality of RyPass, be sure include `file_io_test` at the top of the test. Examples are below.

```ruby
require 'test_helper'

class SomeClassTest
  def test_it_does_something_with_fileIO
    file_io_test
    assert_equal 'I expect this', SomeClass.does_this_work?
  end

  def test_it_does_something_that_does_not_touch_file_io
    assert_equal 'I expect this', SomeClass.does_that_work?
  end
end
```

### Running Tests

Run `rake -T` to see the two options for running tests.
- `rake test:all` will run all of the tests, including FileIO tests which will create a `test.csv` file (and delete it).
- `rake test:core` will run all of the tests EXCEPT FileIO tests. This ensures quicker processing while working on features that don't touch the FileIO functionality.

## Documentation

If adding new functionality, be sure to keep the documentation up-to-date. We use [YARD](http://yardoc.org/) for documentation. Be sure to follow the style present throughout the codebase and refer to docs for any additional questions. For functions, write a description, parameters (if any), and the return value (if non-void).

## Pull Requests

All branches should be based off the `development` branch and written using the following format, `ISSUE_NUMBER-SUMMARY-OF-ISSUE` (ex: `12-create-contributing`). Before submitting a pull request, run `rake test:all` in the top-level directory to verify that all tests are passing. Make your pull request to `development` unless stated otherwise in the issue tracker. We will check for new pull requests at the end of every day and review/ comment on them as necessary.
