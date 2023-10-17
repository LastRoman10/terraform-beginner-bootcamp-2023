# Terraform Beginner Bootcamp 2023 Week2

## Working with Ruby

#### Bundler

Bundler is a package mamnager for ruby, it is the primary way to install ruby packages
(known as gems) for ruby

#### Install Gems
You need to create a Gemfile and define your gems in that file

```rb
source "https://rubygems.org"

gem 'sinatra'
gem 'rake'
gem 'pry'
gem 'puma'
gem 'activerecord'
```

Then you need to run the `bundle install command`.

This will install the gems on the system globally unlike nodejs that that installs packages in a 
folfer called node_modules

A Gemfile.lock file will be created to lock down the gem versions used in this project.

#### Executing ruby scripts in the contect of bundler

We have to use `bundle exec` to tell future ruby scripts to use the gems we installed. This is the way we set context.

### Sinatra

This is a micro-web framework for ruby to build web-apps.

It's great for mock or development servers or for very simple projects.

You can create a webserver in a sinlge file

https://sinatrarb.com/

## Terratowns Mock Server

### Running the web server

We can run the webserver by running the following commands:

```rb
bundle install
bundle exec ruby server.rb
```

All of the code for our server is stored in the `server.rb` file

## CRUD

Terraform Provider resources utilizes CRUD i.e Create, Read, Update and Delete