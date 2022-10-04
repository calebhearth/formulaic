# Formulaic

[![Build Status](https://travis-ci.org/calebhearth/formulaic.png?branch=master)](https://travis-ci.org/calebhearth/formulaic)
[![Code Climate](https://codeclimate.com/github/calebhearth/formulaic.png)](https://codeclimate.com/github/calebhearth/formulaic)

Remove the tedium of formulaic form filling with Capybara.

Formulaic allows you to specify a hash of attributes to be input rather than
procedurally calling Capybara’s DSL methods.

## Usage
```ruby
  gem 'formulaic', group: :test
```

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
fill_form(model_name, :new, attributes)
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
submit(model_name, :create)
```

`submit` functions like [`input`](#input), but finds the translation for the
submit button of the form. `model_name` should be the same as what you provide
to [`fill_form`](#fill\_form). Typically, the return value of `submit` will be
passed directly to Capybara’s `click_on` method.

If you are submitting a form that is not for the `create` action, you may need
to pass the action:

```ruby
submit(:user, :update)
```

The `model_name` and `action` should match up to the
`helpers.submit.<model_name>.<action>` translations.

### `fill_form_and_submit`

```ruby
fill_form_and_submit(:user, :new, attributes)
```

Effectively a `fill_form` followed by `click_on submit`, but smart enough to
`fill_form` with `:new` and `submit` with `:create` and the edit/update cousin.

### Nested Forms

If you have nested forms, through `fields_for` (or any variant), you are able to
fill them with an extra call to `fill_form`.

```ruby
fill_form(main_model_name, main_model_attributes)
fill_form(nested_model_name, nested_model_attributes)
```

### Integration with RSpec:

```ruby
# spec/spec_helper.rb

RSpec.configure do |config|
  config.include Formulaic::Dsl, type: :feature
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

### Integration with [Factory Bot](https://github.com/thoughtbot/factory_bot)

```ruby
fill_form(:user, attributes_for(:user))
```

You may have attributes included in your `User` factory that don’t pertain to
sign up:

```ruby
fill_form(:user, attributes_for(:user).slice(*sign_up_attributes))

# ...
def sign_up_attributes
  [:name, :email, :terms_of_service]
end
```

### Integration with [Capybara::TestHelper](https://github.com/ElMassimo/capybara_test_helpers)

```ruby
class BaseTestHelper < Capybara::TestHelper
  include Formulaic::Dsl
end
```

or alternatively delegate the needed methods:

```ruby
class FormTestHelper < BaseTestHelper
  delegate_to_test_context(:fill_form, :input, :submit, :fill_form_and_submit)
end
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

Formulaic assumes your forms don't use AJAX, setting the wait time to 0. This can be configured using:
```ruby
Formulaic.default_wait_time = 5
```

## Known Limitations

* Formulaic currently supports the following mappings from the `#class` of the
  attribute values to Capybara method calls:

  | Classes                               | Formulaic’s action               |
  | --------------------------------------|----------------------------------|
  | `String`                              | `fill_in`, `choose`, or `select` |
  | `Date`, `ActiveSupport::TimeWithZone` | `select` year, month, and day    |
  | `TrueClass`                           | `check`                          |
  | `FalseClass`                          | `uncheck`                        |
  | `Array`                               | `check` or `select` each array member, which should all be strings. If not all items can be selected or checked, an error will be thrown.|
  | `File`                                | `attach_file` with `File#path`   |

* Formulaic is currently tied to `simple_form` translations and field structure.
  If you pass a string for the attribute, we’ll try to fill the input that
  relates to that label. We would be happy to work with you to add support for
  other form builders.
* Formulaic currently does not support forms with duplicate labels, as it is
  designed to be as similar as possible to a user completing a form—it looks at
  the labels to determine where to fill what data.
* Formulaic can’t figure out how to fill fields with HTML labels:
  `page.fill_in('<strong>Text</strong> here', with: 'something')` doesn’t work
  with Capybara. The usual workaround is to pass a CSS selector (which you can
  do by passing a string as the attribute key).
* Formulaic can't handle multiple file attachments on the same input.

## About

Formulaic is maintained by [Caleb Hearth][caleb] and formerly thoughtbot with
the help of community [contributors]. Thank you!

[caleb]: http://github.com/calebhearth
[contributors]: http://github.com/thoughtbot/calebhearth/contributors
