# Flare

Flare is a utility for generating smoke tests and integration tests against
distributed systems.

## Configuration
Flare is configured using the Dotenv gem. Any particular settings can be defined
in the .env, like so:

```
FOO=bar
```

## Defining a Service
A service is a web service or API with one or many endpoints. You can define it
like so:
```ruby
class MyService < Flare::Service
  def self.to_sym
    :my_service
  end

  def get_a_thing(options = {})
    get("/a-thing", options)
  end
end
```

## Overriding headers
In certain situations (such as authentication), you'll want to send the same set
of headers to every service. You can override them:
```ruby
class AuthenticationService < Flare::Service
  def self.to_sym
    :authentication_service
  end

  def authenticate(options = {})
    post("authenticate", options).tap do |response|
      self.class.superclass.set_headers({
        'Authorization' => "Token token=#{response.fetch('token')}"
      })
    end
  end
end
```

## Defining a Flow
Flows are a set of API calls that compose a particular business process.
```ruby
class MyFlow < Flare::Flow
  step MyService \
    :get_a_thing,
    { foo: 'bar' },
    :on_thing_fetched

  class << self
    def on_thing_fetched(response)
      puts response
    end
  end
end
```

`step` takes two to four arguments: the service class, the method name as a symbol
on that method, any additional arguments as a hash, and a method name for a callback.
The options hash and callback may also be defined as lambdas.

## Defining a Process
```ruby
class MyProcess < Flare::Process
  flow MyFlow
  flow MySecondFlow
end
```

## Chaining Flows in a process
Any `Flare::Flow` can optionally implement `self.result` and return a hash, which
will be chained into the next flow defined in a process and available in any step
as `@_input`. For instance:
```ruby
class MyFlow < Flare::Flow
  step MyService \
    :get_a_thing,
    {},
    :on_thing_fetched

  class << self
    def result
      { thing: @_thing }
    end

    def on_thing_fetched(response)
      @_thing = response
    end
  end
end

class MySecondFlow < Flare::Flow
  step MyService \
    :post_a_thing,
    :post_thing_params

  class << self
    def post_thing_params
      { input: @_input.fetch(:thing) }
    end
  end
end

class MyProcess < Flare::Process
  flow MyFlow
  flow MySecondFlow
end
```

## Overriding the HTTP Adapter

## Overriding the logger

## Debug mode
