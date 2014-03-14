# Formulaic

[![Build Status](https://travis-ci.org/thoughtbot/formulaic.png?branch=master)](https://travis-ci.org/thoughtbot/formulaic)
[![Code Climate](https://codeclimate.com/github/thoughtbot/formulaic.png)](https://codeclimate.com/github/thoughtbot/formulaic)

Remove the tedium of formulaic form filling with Capybara.

Formulaic allows you to specify a hash of attributes to be input rather than
procedurally calling Capybara’s DSL methods.

## Usage

```ruby
feature 'New user registration' do
  scenario 'successfull sign up' do
    visit sign_in_path

    fill_form(:user, { name: 'Caleb', email: 'caleb@thoughtbot.com', 'Terms of Service' => true })
    click_on submit(:user)

    expect(page).to have_content t('user.create.success')
  end
end
```


### `fill_form`

```ruby
fill_form(model_name, attributes)
```

`fill_form` provides an interface to completely filling out a form. Provide the
`model_name` as a symbol and `attributes` as a hash of
`column name => database value` or `label string => database value`.

If an `attributes` key is a `String`, it will be used as the literal label.
For `Symbol` we will attempt to translate, fall back to `human_attribute_name`
if available, then call `to_s`.

### `input`

```ruby
input(model_name, field)
```

`input` gives an easy way to find the translated text of an input. It is
primarily used internally to fill `<input>`s, but is provided in the public API
as it could be useful.

### `submit`

```ruby
submit(model_name, action = :create)
```

`submit` functions like [`input`](#input), but finds the translation for the
submit button of the form. `model_name` should be the same as what you provide
to [`fill_form`](#fill\_form). Typically, the return value of `submit` will be
passed directly to Capybara’s `click_on` method.

If you are submitting a form that is not for the `create` action, you may need
to pass the `action`:

```ruby
submit(:user, :update)
```

The `model_name` and `action` should match up to the
`helpers.submit.<model_name>.<action>` translations.

### Integration with RSpec:

```ruby
# spec/spec_helper.rb

RSpec.configure do |config|
  config.include Formulaic::Dsl
end
```

### Integration with Minitest or Test::Unit:

```ruby
# test/test_helper.rb

class ActionDispatch::IntegrationTest
  include Capybara::DSL
  include Formulaic::Dsl
end
```

### Integration with [FactoryGirl](https://github.com/thoughtbot/factory_girl)

```ruby
require 'formulaic/factory_girl'

fill_with_factory(:user, attributes_for(:user))
```

You may have attributes included in your `User` factory that don’t pertain to
sign up:

```ruby
require 'formulaic/factory_girl'

fill_with_factory(:user, :name, :email, :terms_of_service)
```

If you need to pass specific arguments to the factory, such as [traits] or to
override values, pass them in the `factory_arguments` parameter.

[traits]: https://github.com/thoughtbot/factory\_girl/blob/master/GETTING\_STARTED.md#traits

```ruby
require 'formulaic/factory_girl'

fill_with_factory(:user, factory_arguments: [:registered, name: 'Frank'])
```

Which is roughly equivalent to calling:

```ruby
fill_form(:user, attributes_for(:user, :registered, name: 'Frank'))
```

## Assumptions

Formulaic relies pretty heavily on the assumption that your application is using
translations for SimpleForm and input helpers, using the
`simple_form.labels.<model>.<attribute>` and `helpers.submit.<model>.<action>`
conventions.

You can still use Formulaic by using strings as keys instead of symbols, which
it knows to pass directly to `fill_in` rather than trying to find a translation.
You’ll need to find submit buttons yourself since `submit` is a thin wrapper
around `I18n.t`.

## Known Limitations

* Formulaic currently supports the following mappings from the `#class` of the
  attribute values to Capybara method calls:

  | Classes                               | Formulaic’s action               |
  | --------------------------------------|----------------------------------|
  | `String`                              | `fill_in`, `choose`, or `select` |
  | `Date`, `ActiveSupport::TimeWithZone` | `select` year, month, and day    |
  | `TrueClass`                           | `check`                          |
  | `FalseClass`                          | `uncheck`                        |
  | `Array`                               | `check` each array member, which should all be strings |

* Formulaic is currently tied to `simple_form` translations and field structure.
  If you pass a string for the attribute, we’ll try to fill the input that
  relates to that label. We would be happy to work with you to add support for
  other form builders.
* Formulaic currently does not support forms with duplicate labels, as it is
  designed to be as similar as possible to a user completing a form—it looks at
  the labels to determine where to fill what data.
* Formulaic can’t figure out how to fill fields with HTML labels:
  `page.fill_in('<strong>Text</strong> here', with: 'something')` doesn’t work
  with Capybara. The usual workaround is to pass a CSS selector.

## About

Formulaic is maintained by [Caleb Thompson](http://github.com/calebthompson).
It was written by [thoughtbot](http://thoughtbot.com) with the help of our
[contributors](http://github.com/thoughtbot/formulaic/contributors).

[![Ralph](http://thoughtbot.com/assets/thoughtbot-logo.png)](http://thoughtbot.com)
