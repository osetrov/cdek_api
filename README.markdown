# СДЭК АПИ

API wrapper для СДЭК [API](https://api-docs.cdek.ru/29923741.html).

## Установка Ruby

    $ gem install cdek_api

## Установка Rails

добавьте в Gemfile:

    gem 'cdek_api'

и запустите `bundle install`.

Затем:

    rails g cdek_api:install

## Требования

Необходимо запросить CLIENT_ID и CLIENT_SECRET для production

## Использование Rails

В файл `config/cdek_api.yml` вставьте ваши данные

## Использование Ruby

Сначала cгенерируйте access_token
Затем создайте экземпляр объекта `CdekApi::Request`:

```ruby
access_token = CdekApi.generate_access_token('EMscd6r9JnFiQ3bLoyjJY6eM78JrJceI', 'PjLZkKBHEiLK3YsjtNrt3TGNG0ahs3kG', 'client_credentials')
delivery = CdekApi::Request.new(access_token: access_token)
```

Вы можете изменять `access_token`, `timeout`, `open_timeout`, `faraday_adapter`, `proxy`, `symbolize_keys`, `logger`, и `debug`:

```ruby
CdekApi::Request.access_token = "your_access_token"
CdekApi::Request.timeout = 15
CdekApi::Request.open_timeout = 15
CdekApi::Request.symbolize_keys = true
CdekApi::Request.debug = false
```

Либо в файле `config/initializers/cdek_api.rb` для Rails.

## Debug Logging

Pass `debug: true` to enable debug logging to STDOUT.

```ruby
delivery = CdekApi::Request.new(access_token: "your_access_token", debug: true)
```

### Custom logger

Ruby `Logger.new` is used by default, but it can be overrided using:

```ruby
delivery = CdekApi::Request.new(access_token: "your_access_token", debug: true, logger: MyLogger.new)
```

Logger can be also set by globally:

```ruby
CdekApi::Request.logger = MyLogger.new
```

## Примеры

```ruby
  CdekApi::Request.location.regions.retrieve.body
```