Spree Permalink Redirects
=========================

This gem adds a history for product and taxon permalinks. The history is then used to automatically provide HTTP redirects for anyone making a request against the old permalink. The history is maintained automatically by ActiveRecord dirty flags and callbacks, thus changes can be made to a product's permalink and all of the SEO changes will be handled automatically.

Understanding SEO (Search Engine Optimization)
----------------------------------------------

In order to understand the purpose of this gem, it helps to understand how Google (and other search engines) operate.

A typical product RESTful product URL looks like this:

```
GET /product/1
```

The first thing that people will tell you is that you need to have a more friendly URL for Google. Thus the URL turns into something like this:

```
GET /product/awesome-pants
```

Spree supports this via the permalink attribute on a Spree::Product.

But what happens when you change awesome-pants to really-awesome-pants. By default, Spree will respond HTTP 404, missing. This is bad for a) user's that currently have in their history/bookmarks the old URL. But b) it's also bad for SEO; all of the link karma/juice that Google has sent to awesome-pants will be lost.

The first idea is to simply keep track of the history, and still load the product. The problem with this idea is that Google penalizes for duplicate content. They don't like it when /product/awesome-pants and /product/really-awesome-pants point to the same exact piece of content. They'll think you're spamming their results and drop your search rankings. 

The proper thing to do, for both users and SEO is to redirect, that is to HTTP 302 and tell the world that the content you are looking for has moved permanently. This gets user's to the new product page, it gets Google to the new product page, it keeps your link karma happy, and protects you against duplicate content warnings.

How It Works
------------

We create a new model Spree::PermalinkRedirect in this Gem.

We then class_eval into Spree::Product and Spree::Taxon to add event callbacks to listen to any changes on the permalink. If there is a change, we store the change as a Spree::PermalinkRedirect. In the API and Frontend controllers, we add an additional check before ActiveRecord::RecordNotFound is handled by the controller. This check attempts to see for a product/taxon, does the permalink exist and if so, load the appropriate model. The response is then sent as HTTP 302 with Location pointing to the right product URL or taxon URL. 

Since there can be many /foo permalinks the tie breaker is to always pick the most recent one, and send to that product or taxon.

Installation
------------

Add spree_permalink_redirects to your Gemfile:

```ruby
gem 'spree_permalink_redirects'
```

Bundle your dependencies and run the installation generator:

```shell
bundle
bundle exec rails g spree_permalink_redirects:install
```

Testing
-------

Be sure to bundle your dependencies and then create a dummy test app for the specs to run against.

```shell
bundle
bundle exec rake test_app
bundle exec rspec spec
```

When testing your applications integration with this extension you may use it's factories.
Simply add this require statement to your spec_helper:

```ruby
require 'spree_permalink_redirects/factories'
```

Copyright (c) 2014 [Hoyaboya], released under the New BSD License
