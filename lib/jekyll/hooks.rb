module Jekyll
  module Hooks

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

  end
end
