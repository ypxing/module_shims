# Module::Shims

The gem is one tool used for debugging/developing Ruby projects and as one helper for reading/trying source code of Ruby projects (like source code of Ruby on Rails).
It should NOT be used for production.

In one inheritance chain like [A, B, C, D], it can add shim module to anyone of them so that you can "replace" one method's implementation of one specific module/class with your own implementation without impacting other modules/classes.

Different from monkey patch, you can freely enable/disable your implementation. You can maitain many of your implementation and enable them whenever you want to debug/develop your projects.

It makes use of Module#prepend of Ruby (>= 2.0)

See example in Usage section.

## Installation

Add this line to your application's Gemfile (for development/test groups):

```ruby
gem 'module_shims'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install module_shims

## Usage

For below inheritance chain [BClass, AModule]
```ruby
  module AModule
    def target
      'a_module'
    end
  end

  class BClass
    include AModule

    def target
      'b_class'
    end

    def irrelevant
    end
  end
```

Let's hook method "target"
```ruby

  # give BClass one outer namespace.
  module Mine
    module BClass
      extend ModuleShims::Switch

      def target
        "mine with #{super}"
      end
    end
  end

  Mine::BClass.enable_shim
  # your target will be used from this line

  BClass.new.target # "mine with a_module"

  Mine::BClass.disable_shim
  # original target will be used from this line

  BClass.new.target # "b_class"

```

You can keep BClass's method implementation in the inheritance chain like

```ruby
  Mine::BClass.enable_shim(false)
  BClass.new.target # "mine with b_class"

```

## Note for adding shim to one module.

For existing module M, below code cannot impact existing classes which have already included M.
```ruby
Fake::M.enable_shim
```
To cover this case, you can put simliar code at the beginning of the boot of your project.

It just makes use of TracePoint and inserts the shim when M is defined.
You can put all your "fake" modules in below code.

```ruby
trace = TracePoint.new(:class) do |tp|
  src_mod =
    %w(
      Fake::M
    ).find { |src| tp.self.name == src.gsub(/\A[^:]+::/, '') }

  src_mod.constantize.insert_shim if src_mod
end

trace.enable
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/module_shims.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

