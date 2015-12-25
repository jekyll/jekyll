module Jekyll
  module Hooks
<<<<<<< HEAD
    DEFAULT_PRIORITY = 20

    # compatibility layer for octopress-hooks users
    PRIORITY_MAP = {
      low: 10,
      normal: 20,
      high: 30,
    }.freeze

    # initial empty hooks
    @registry = {
      :site => {
        after_reset: [],
        post_read: [],
        pre_render: [],
        post_render: [],
        post_write: [],
      },
      :pages => {
        post_init: [],
        pre_render: [],
        post_render: [],
        post_write: [],
      },
      :posts => {
        post_init: [],
        pre_render: [],
        post_render: [],
        post_write: [],
      },
      :documents => {
        post_init: [],
        pre_render: [],
        post_render: [],
        post_write: [],
      },
    }

    # map of all hooks and their priorities
    @hook_priority = {}

    NotAvailable = Class.new(RuntimeError)
    Uncallable = Class.new(RuntimeError)

    # register hook(s) to be called later, public API
    def self.register(owners, event, priority: DEFAULT_PRIORITY, &block)
      Array(owners).each do |owner|
        register_one(owner, event, priority_value(priority), &block)
      end
    end

    # Ensure the priority is a Fixnum
    def self.priority_value(priority)
      return priority if priority.is_a?(Fixnum)
      PRIORITY_MAP[priority] || DEFAULT_PRIORITY
    end

    # register a single hook to be called later, internal API
    def self.register_one(owner, event, priority, &block)
      @registry[owner] ||={
        post_init: [],
        pre_render: [],
        post_render: [],
        post_write: [],
      }

      unless @registry[owner][event]
        raise NotAvailable, "Invalid hook. #{owner} supports only the " <<
          "following hooks #{@registry[owner].keys.inspect}"
      end

      unless block.respond_to? :call
        raise Uncallable, "Hooks must respond to :call"
      end

      insert_hook owner, event, priority, &block
    end

    def self.insert_hook(owner, event, priority, &block)
      @hook_priority[block] = "#{priority}.#{@hook_priority.size}".to_f
      @registry[owner][event] << block
    end

    # interface for Jekyll core components to trigger hooks
    def self.trigger(owner, event, *args)
      # proceed only if there are hooks to call
      return unless @registry[owner]
      return unless @registry[owner][event]

      # hooks to call for this owner and event
      hooks = @registry[owner][event]

      # sort and call hooks according to priority and load order
      hooks.sort_by { |h| @hook_priority[h] }.each do |hook|
        hook.call(*args)
      end
    end
=======

    class HookCollection
      include Enumerable

      def each(&block)
        if block.nil?
          hook_methods
        else
          hook_methods.each &block
        end
      end

      def hook_methods
        @hook_methods ||= Array.new
      end

      def add_hook(proc)
        hook_methods << proc
      end

      def exec(*args)
        if args.empty?
          hook_methods.each { |hook| hook.call }
        else
          hook_methods.each do |hook|
            args.each { |arg| hook.call(arg) }
          end
        end
      end

    end

    %w[
      post_reset
      pre_read
      post_read
      pre_generate
      post_generate
      pre_render
      post_render
      pre_cleanup
      post_cleanup
      pre_write
      post_write
    ].each do |method|
      declaration = <<-METH
      def #{method}(method_name, *args)
        cr = caller
        ((@hooks ||= Hash.new).fetch(method_name.to_s, HookCollection.new)).add_hook -> { cr.send(method_name.to_sym, args) }
      end
      def #{method}_exec(*args)
        ((@hooks ||= Hash.new).fetch(method_name.to_s, HookCollection.new)).exec(*args)
      end
METH
puts declaration
      class_eval declaration
    end

>>>>>>> jekyll/hooks
  end
end
