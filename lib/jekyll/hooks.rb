module Jekyll
  module Hooks
    # initial empty hooks
    @registry = {
      Jekyll::Site => {
        reset: [],
        post_read: [],
        pre_render: [],
        post_write: [],
      },
      Jekyll::Page => {
        post_init: [],
        pre_render: [],
        post_render: [],
        post_write: [],
      },
      Jekyll::Post => {
        post_init: [],
        pre_render: [],
        post_render: [],
        post_write: [],
      },
    }

    NotAvailable = Class.new(RuntimeError)

    # register a hook to be called later
    def self.register(klass, event, &block)
      unless @registry[klass]
        raise NotAvailable, "Hooks are only available for the following " <<
          "classes: #{@registry.keys.inspect}"
      end

      unless @registry[klass][event]
        raise NotAvailable, "Invalid hook. #{klass} supports only the " <<
          "following hooks #{@registry[klass].keys.inspect}"
      end

      @registry[klass][event] << block
    end

    # interface for Jekyll core components to trigger hooks
    def self.trigger(instance, event, *args)
      # proceed only if there are hooks to call
      return unless @registry[instance.class]
      return unless @registry[instance.class][event]

      @registry[instance.class][event].each do |hook|
        hook.call(instance, *args)
      end
    end
  end
end
