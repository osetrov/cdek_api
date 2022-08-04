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

### [Запрос на регистрацию заказа](https://api-docs.cdek.ru/29923926.html).

```ruby
request = {
  "number": "ddOererre7450813980068",
  "comment": "Новый заказ",
  "delivery_recipient_cost": {
    "value": 50
},
  "delivery_recipient_cost_adv": [ {
                                      "sum": 3000,
                                      "threshold": 200
                                    } ],
  "from_location": {
    "code": "44",
    "fias_guid": "",
    "postal_code": "",
    "longitude": "",
    "latitude": "",
    "country_code": "",
    "region": "",
    "sub_region": "",
    "city": "Москва",
    "kladr_code": "",
    "address": "пр. Ленинградский, д.4"
  },
  "to_location": {
    "code": "270",
    "fias_guid": "",
    "postal_code": "",
    "longitude": "",
    "latitude": "",
    "country_code": "",
    "region": "",
    "sub_region": "",
    "city": "Новосибирск",
    "kladr_code": "",
    "address": "ул. Блюхера, 32"
  },
  "packages": [ {
                   "number": "bar-001",
                   "comment": "Упаковка",
                   "height": 10,
                   "items": [ {
                     "ware_key": "00055",
                   "payment": {
                     "value": 3000
                 },
                 "name": "Товар",
  "cost": 300,
  "amount": 2,
  "weight": 700,
  "url": "www.item.ru"
} ],
  "length": 10,
  "weight": 4000,
  "width": 10
} ],
  "recipient": {
    "name": "Иванов Иван",
    "phones": [ {
      "number": "+79134637228"
  } ]
},
  "sender": {
    "name": "Петров Петр"
  },
  "services": [ {
                   "code": "SECURE_PACKAGE_A2"
                 } ],
  "tariff_code": 139
}

response = CdekApi::Request.orders.create(body: request)
p response.body
#=> {:entity=>{:uuid=>"72753031-7c5a-49ba-ba35-18d82b0d9b14"}, :requests=>[{:request_uuid=>"2c5f8397-0ce5-46b2-a097-39a32625da2d", :type=>"CREATE", :date_time=>"2022-08-04T01:25:12+0700", :state=>"ACCEPTED"}]}         
```

### [Информация о заказе](https://api-docs.cdek.ru/29923975.html).

```ruby
CdekApi::Request.orders("72753031-7c5a-49ba-ba35-18d82b0d9b14").retrieve.body
```

```ruby
CdekApi::Request.orders.retrieve(params: {cdek_number: 1106207812}).body
```

```ruby
CdekApi::Request.orders.retrieve(params: {im_number: "00004792842619"}).body
```

### [Изменение заказа](https://api-docs.cdek.ru/36981178.html).
```ruby
request = {
  "uuid":"72753031-5427-4d1b-b1e4-7c4c26be00a0",
  "cdek_number":"1105660806",
  "tariff_code":"10",
  "sender":{
    "company":"Pogoda",
    "name":"Петров Петр",
    "email":"react@cdek.ru",
    "phones":[
      {
        "number":"+79134637228",
        "additional":"1234"
      }
    ]
  },
  "recipient":{
    "company":"NUMM",
    "name":"Константинов Константин",
    "email":"pochta@gmail.com",
    "phones":[
      {
        "number":"+79134635628",
        "additional":"123"
      }
    ]
  },
  "to_location":{
    "code":"137"
  },
  "from_location":{
    "address":"Новосибирск, Большевистская 101"
  },
  "services":[
    {
      "code":"DANGER_CARGO"
    },
    {
      "code":"PACKAGE_1",
      "parameter":"1"
    }
  ],
  "packages":[
    {
      "number":"bar-666",
      "height":20,
      "length":20,
      "weight":4000,
      "width":20,
      "items":[
        {
          "name":"Товар",
          "ware_key":"00055",
          "payment":{
            "value":3000
          },
          "cost":300,
          "amount":1,
          "weight":700
        }
      ]
    }
  ]
}

CdekApi::Request.orders.update(body: request).body
```

### [Удаление заказа](https://api-docs.cdek.ru/29924487.html).
```ruby
CdekApi::Request.orders("72753031-7c5a-49ba-ba35-18d82b0d9b14").delete.body
```

### [Регистрация отказа](https://api-docs.cdek.ru/55327658.html).
```ruby
CdekApi::Request.orders("72753031-826d-4ef7-b127-1074f405b269").refusal.create.body
```

### [Список офисов](https://api-docs.cdek.ru/36982648.html).
```ruby
CdekApi::Request.deliverypoints.retrieve(params: {weight_max: 50, city_code: 270, allowed_cod: 1}).body
```

### [Калькулятор. Расчет по доступным тарифам](https://api-docs.cdek.ru/63345519.html).
```ruby
request = {
  "type": 1,
  "date": "2020-11-03T11:49:32+0700",
  "currency": 1,
  "lang": "rus",
  "from_location": {
    "code": 270
  },
  "to_location": {
    "code": 44
  },
  "packages": [
    {
      "height": 10,
      "length": 10,
      "weight": 4000,
      "width": 10
    }
  ]
}
CdekApi::Request.calculator.tarifflist.create(body: request).body
```

### [Калькулятор. Расчет по коду тарифа](https://api-docs.cdek.ru/63345430.html).
```ruby
request = {
  "type": "2",
  "date": "2020-11-03T11:49:32+0700",
  "currency": "1",
  "tariff_code": "11",
  "from_location": {
    "code": 270
  },
  "to_location": {
    "code": 44
  },
  "services": [
    {
      "code": "CARTON_BOX_XS",
      "parameter": "2"
    }
  ],
  "packages": [
    {
      "height": 10,
      "length": 10,
      "weight": 4000,
      "width": 10
    }
  ]
}
CdekApi::Request.calculator.tariff.create(body: request).body
```

### [Список регионов](https://api-docs.cdek.ru/33829418.html).

```ruby
CdekApi::Request.location.regions.retrieve.body
```

### [Список населенных пунктов](https://api-docs.cdek.ru/33829437.html).

```ruby
CdekApi::Request.location.cities.retrieve(params: {city: "Санкт-Петербург"}).body
```