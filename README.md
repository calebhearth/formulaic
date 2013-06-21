# Formulaic

Remove the tedium of formulaic form filling with Capybara.

Formulaic allows you to specify a hash of attributes to be input rather than
procedurally calling Capybara’s DSL methods.

## Usage

```ruby
feature 'New user registration' do
  scenario 'succesfull sign up' do
    visit sign_in_path

    fill_form(:user, { name: 'Caleb', email: 'caleb@thoughtbot.com', 'Terms of Service': true })
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

### Integration with [FactoryGirl](https://github.com/thoughtbot/factory_girl)

```ruby
fill_form(:user, attributes_for(:user))
```

You may have attributes included in your `User` factory that don’t pretain to
sign up:

```ruby
fill_form(:user, attributes_for(:user).slice(sign_up_attributes))

# ...
def sign_up_attributes
  [:name, :email, :terms_of_service]
end
```

## Known Limitations

Formulaic currently supports the following mappings from the `#class` of the
attribute values to Capybara method calls:

| Classes                               | Formulaic’s action            |
| --------------------------------------|-------------------------------|
| `String`                              | `fill_in`                     |
| `Date`, `ActiveSupport::TimeWithZone` | `select` year, month, and day |
| `TrueClass`                           | `check`                       |
| `FalseClass`                          | `uncheck`                     |
| `Array`                               | `check` each array member, which should all be strings |

Formulaic is currently tied to `simple_form` translations and field structure.
We would be happy to work with you to add support for other form builders.

## About

Formulaic is maintained by [Caleb Thompson](http://github.com/calebthompson).
It was written by [thoughtbot](http://thoughtbot.com) with the help of our
[contributors](http://github.com/calebthompson/formulaic/contributors).

[![Ralph](http://thoughtbot.com/assets/thoughtbot-logo.png)](http://thoughtbot.com)
