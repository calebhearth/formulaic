# Contributing

We love pull requests. Here's a quick guide:

1. Fork the repo.
2. Run the tests. We only take pull requests with passing tests, and it's great
   to know that you have a clean slate: `bundle && rake`
3. Add a test for your change. Only refactoring and documentation changes
   require no new tests. If you are adding functionality or fixing a bug, we need
   a test!
4. Make the test pass.
5. Make sure your changes adhere to the [thoughtbot Style
   Guide](https://github.com/thoughtbot/guides/tree/master/style)
6. Push to your fork and submit a pull request.
7. At this point you're waiting on us. We like to at least comment on, if not
   accept, pull requests within three business days (and, typically, one business
   day). [We may suggest some changes or improvements or
   alternatives](https://github.com/thoughtbot/guides/tree/master/code-review).

## Increase your chances of getting merged

Some things that will increase the chance that your pull request is accepted,
taken straight from the Ruby on Rails guide:

* Use Rails idioms and helpers
* Include tests that fail without your code, and pass with it
* Update the documentation: that surrounding your change, examples elsewhere,
  guides, and whatever else is affected by your contribution
* Syntax:
    * Two spaces, no tabs.
    * No trailing whitespace. Blank lines should not have any space.
    * Make sure your [source files end with newline
      characters](http://stackoverflow.com/questions/729692/why-should-files-end-with-a-newline#answer-729725).
    * Prefer `&&`/`||`  over `and`/`or`.
    * `MyClass.my_method(my_arg)` not `my_method( my_arg )` or
      `my_method my_arg`.
    * `a = b` and not `a=b`.
    * Follow the conventions you see used in the source already.
* And in case we didn't emphasize it enough: *We love tests!*
