Spree extension for [Mad Mimi](https://madmimi.com)
============

Mad Mimi's Spree extension allows you to easily import your product listings and buyer email addresses for a super efficient email integration.

Installation
------------

**Update your Gemfile**

Add spree_madmimi to your Gemfile:

```ruby
gem 'spree_madmimi', github: 'godaddy/spree_madmimi', branch: '2-2-stable'
gem 'omniauth-madmimi', github: 'madmimi/omniauth-madmimi'
```

**Install**

Bundle your dependencies and run the installation generator:

```shell
bundle
bundle exec rails g spree_madmimi:install
```

**Obtain Mad Mimi credentials**

Get your Application ID and Secret from Mad Mimi:

1. Visit [Mad Mimi applications](http://madmimi.com/oauth/applications).
2. Click "New Application" button.
3. For `name` use any string *(e.g. Spree Store)*.
4. For `redirect uri` use your domain plus `/auth/madmimi/callback` *(e.g. http://example.com/auth/madmimi/callback)*.

**Configure Mad Mimi**

Add madmimi configuration to `config/application.rb` file:

```ruby
config.madmimi = {
  client_id:     '...your MadMimi Application ID...',
  client_secret: '...your MadMimi Secret...'
}
```

Don't forget to replace Application ID and Secret with your Mad Mimi credentials.


Configuration
-------------

Go to the admin section of your Spree store and visit: **Configurations &rarr; Mad Mimi**.

There you can connect your existing [Mad Mimi](https://madmimi.com) account or create a new one.

Once you've set up your connection, you can choose one of your Mad Mimi webforms to use as the subscribe form for your store.

Usage
-----

You can use your Mad Mimi integration in various ways:

To import your existing customers into Mad Mimi, sign in into your account, visit [Spree addon's page][1] and click "Import" button. You will receive a notification once it is ready.

When you link your Spree store, the newsletter composer will have a new "Products" tab containing your active listings. From there you can drag and drop a listing into either a text or image field to automatically add the description or photo.

Create sign up forms to allow people to subscribe to your audience lists. Integrate them into Spree store by choosing webform in the Mad Mimi configuration section of your store.

If you need to embed webform into your store's design, use `mad_mimi_webform` helper with `webform id` as the first argument and `:plain` as the second, e.g.:

```ruby
<%= mad_mimi_webform(123, :plain) %>
```

Testing
-------

First bundle your dependencies, then run `rake`. `rake` will default to building the dummy app if it does not exist, then it will run specs. The dummy app can be regenerated by using `rake test_app`.

```shell
bundle
bundle exec rake
```

When testing your applications integration with this extension you may use it's factories.
Simply add this require statement to your spec_helper:

```ruby
require 'spree_madmimi/factories'
```

Copyright (c) 2014 Mad Mimi, released under the New BSD License


  [1]: http://madmimi.com/spree/edit
