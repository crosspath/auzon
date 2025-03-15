# Auzon

Gem with base code for Rails projects with Clean architecture and Domain-Driven Design.

See [this project](https://github.com/crosspath/tracker) as an example of application based on this gem.

This gem depends on:

* Blueprinter
* Factory Bot
* Rails 8+
* RSpec
* RSwag

## Name

Word "Auzon" is the name of commune (village) in France. See [short information](https://en.wikipedia.org/wiki/Auzon) and also some [information for tourists](https://www.francethisway.com/places/auzon.php) to Auzon.

The author of this gem has never been in Auzon but he would like to.

Also, this word is short and easy to remember. That's the main reason for selecting this word for the name of this gem.

## Usage

Add this line to `Gemfile`:

```ruby
gem "auzon", git: "https://github.com/crosspath/auzon"
```

Run `bundle install` and then generate code examples and configuration files:

```shell
bin/rails g auzon init
```

This command creates directory `domains` in project root for your domain (business logic) files.

Also you may use these generators:

1. Create directory with typical structure for a domain.

    ```shell
    bin/rails g auzon:domain ...
    ```

    You may input more than one domain name. Domain name should be given with underscores if needed.

    Example:

    ```shell
    bin/rails g auzon:domain site users
    ```

2. Create database migration, other files & directories for new entity.

    ```shell
    bin/rails g auzon:model ...
    ```

    You may input more than one word separated by space. Each word has format `#{domain}/#{model}`. Model name should be given in singular form. Domain name & model name should be given with underscores if needed.

    Example:

    ```shell
    bin/rails g auzon:model site/document users/account
    ```

    This generator creates files:

    * migration file
    * model file (ActiveRecord)
    * form objects files
    * query objects files
    * serializer files
    * service objects files
    * factory file (Factory Bot)

Example structure of directory `domains`:

```
domains
+ base (directory with common files for more than one domain)
+ site (admin panel and site-wide settings)
+ users (all entities that describe user data in this application + related functionality)
| site.rb (adds table_name_prefix for ActiveRecord classes in this namespace)
| users.rb (the same)
```

Short definitions:
1. Domain is a group of tightly coupled functionality & objects.
2. Form (form object) is a class that relates to business entities and is accessible from controllers. Form can validate input data, check user permissions to requested action and pass data to service objects.
3. Job is ActiveJob descendant class. Job can run in synchronous or asynchronous (sequential, parallel) mode depending on business needs and settings for queues. Job uses service objects to perform required actions.
4. Mailer is ActionMailer descendant class. Mailer prepares data for template files, fills template with data and sends result to some recipents (by email).
5. Query (query object) is a class for retrieving collection of records from database or for data aggregation. Similar to forms & services. Query objects can fetch data, but should not change records in database.
6. Serializer is a class for serializing Ruby objects (entities & form results) into Ruby objects (hashes, arrays, numbers, strings, booleans, nils) or JSON. API applications use serializers for generating responses to API calls.
7. Service (service object) is a class for performing some changes in database or external services. Service objects should not be accessible from controllers. Service objects have internal usage only; only form objects, Rake tasks and jobs can (and should only them) call service objects.
8. Validator is a descendant class of ActiveModel::Validator of ActiveModel::EachValidator or some other base class depending on preferred approach for validating user input.

Suggested structure of a domain (e.g. `users`):

```
forms
+ accounts (directory for group of form objects related to create/delete/update/... user accounts)
| | create.rb (example file)
jobs
| deactivate_obsolete_accounts.rb (example file)
mailers (directory for mailers & template files)
+ accounts (directory for template files for accounts.rb)
| | registered.html.slim (example template file)
| accounts.rb (example mailer for notifying users about changes in user accounts)
queries
+ accounts (directory for group of query objects related to user accounts entity)
| | index.rb (example file)
serializers
| account.rb (definition for serializing user account into Ruby Hash or JSON)
services
+ accounts (directory for group of serice objects related to create/delete/update/... user accounts)
| | create.rb (example file)
validators
| unique_email.rb (example file)
account.rb (file with class entity, e.g. for ActiveRecord descendant class)
```

## Development

Do it once — authorize on [RubyGems](https://rubygems.org/) and then:

```shell
gem signin
```

Before release — apply suggestions from RuboCop, review them and commit or reject:

```shell
bin/rubocop --autofix
```

Build `*.gem` file:

```shell
bin/build
```

Try your gem locally, then commit changes in local repository.

Push gem file to rubygems registry and then send new version to remote repository:

```shell
bin/release
```
