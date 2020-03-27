# frozen_string_literal: true

module Jekyll
  module Hooks
    DEFAULT_PRIORITY = 20

    # compatibility layer for octopress-hooks users
    PRIORITY_MAP = {
      :low    => 10,
      :normal => 20,
      :high   => 30,
    }.freeze

    # initial empty hooks
    @registry = {
      :site      => {
        :after_init  => [],
        :after_reset => [],
        :post_read   => [],
        :pre_render  => [],
        :post_render => [],
        :post_write  => [],
      },
      :pages     => {
        :post_init   => [],
        :pre_render  => [],
        :post_render => [],
        :post_write  => [],
      },
      :posts     => {
        :post_init   => [],
        :pre_render  => [],
        :post_render => [],
        :post_write  => [],
      },
      :documents => {
        :post_init   => [],
        :pre_render  => [],
        :post_render => [],
        :post_write  => [],
      },
      :clean     => {
        :on_obsolete => [],
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
      return priority if priority.is_a?(Integer)

      PRIORITY_MAP[priority] || DEFAULT_PRIORITY
    end

    # register a single hook to be called later, internal API
    def self.register_one(owner, event, priority, &block)
      @registry[owner] ||= {
        :post_init   => [],
        :pre_render  => [],
        :post_render => [],
        :post_write  => [],
      }

      unless @registry[owner][event]
        raise NotAvailable, "Invalid hook. #{owner} supports only the " \
          "following hooks #{@registry[owner].keys.inspect}"
      end

      raise Uncallable, "Hooks must respond to :call" unless block.respond_to? :call

      insert_hook owner, event, priority, &block
    end

    def self.insert_hook(owner, event, priority, &block)
      @hook_priority[block] = [-priority, @hook_priority.size]
      @registry[owner][event] << block
    end

    # interface for Jekyll core components to trigger hooks
    def self.trigger(owner, event, *args)
      # proceed only if there are hooks to call
      hooks = @registry.dig(owner, event)
      return if hooks.nil? || hooks.empty?

      # sort and call hooks according to priority and load order
      hooks.sort_by { |h| @hook_priority[h] }.each do |hook|
        hook.call(*args)
      end
    end
  end
end
