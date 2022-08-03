# Ozon-logistics

API wrapper для Ozon.Logistics [API](https://api-stg.ozonru.me/principal-integration-api/swagger/index.html).

## Установка Ruby

    $ gem install ozon-logistics

## Установка Rails

добавьте в Gemfile:

    gem 'ozon-logistics'

и запустите `bundle install`.

Затем:

    rails g ozon_logistics:install

## Требования

Необходимо запросить CLIENT_ID и CLIENT_SECRET для production

## Использование Rails

В файл `config/ozon_logistics.yml` вставьте ваши данные

## Использование Ruby

Сначала cгенерируйте access_token
Затем создайте экземпляр объекта `OzonLogistics::Request`:

```ruby
access_token = OzonLogistics.generate_access_token('ApiTest_11111111-1111-1111-1111-111111111111', 'SRYksX3PBPUYj73A6cNqbQYRSaYNpjSodIMeWoSCQ8U=', 'client_credentials')
delivery = OzonLogistics::Request.new(access_token: access_token)
```

Вы можете изменять `access_token`, `timeout`, `open_timeout`, `faraday_adapter`, `proxy`, `symbolize_keys`, `logger`, и `debug`:

```ruby
OzonLogistics::Request.access_token = "your_access_token"
OzonLogistics::Request.timeout = 15
OzonLogistics::Request.open_timeout = 15
OzonLogistics::Request.symbolize_keys = true
OzonLogistics::Request.debug = false
```

Либо в файле `config/initializers/ozon_logistics.rb` для Rails.

## Debug Logging

Pass `debug: true` to enable debug logging to STDOUT.

```ruby
delivery = OzonLogistics::Request.new(access_token: "your_access_token", debug: true)
```

### Custom logger

Ruby `Logger.new` is used by default, but it can be overrided using:

```ruby
delivery = OzonLogistics::Request.new(access_token: "your_access_token", debug: true, logger: MyLogger.new)
```

Logger can be also set by globally:

```ruby
OzonLogistics::Request.logger = MyLogger.new
```

## Примеры (для версии от 26.04.2021)