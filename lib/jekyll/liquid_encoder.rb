require 'digest/md5'

module Jekyll

  # The LiquidEncoder class encodes a string's liquid commands, preventing them
  # from being munged by converters.
  class LiquidEncoder
    # The encoded content
    attr_reader :encoded_content

    # Six-character salt, generated on initialization
    attr_reader :salt

    # Initialize the LiquidEncoder. If content is provided, will automatically
    # parse content and populate encoded_content. Otherwise, will eagerly await
    # content passed via the +encode+ method.
    #
    # content - a String to be encoded (default: nil).
    #
    # Returns the LiquidEncoder object
    def initialize(content=nil)
       @salt = Digest::MD5.hexdigest(Time.now.nsec.to_s)[0..5]
       @liquid_hash = {}
       @reserved_keys = []
       @current_key = 0

       if content
        encode(content)
      end
    end

    # Encode a string. Takes an optional second argument, +overwrite+, which specifies
    # whether previous encodings should be overwritten. If +overwrite+ is false and this
    # object has already encoded a string (and populated its tag_hash), it will throw a
    # RuntimeException.
    #
    # content - the String to be encoded.
    # overwrite - whether to overwrite previous content (default: false)
    #
    # Returns the encoded string, which can also be accessed via encoded_content
    def encode(content, overwrite=false)
      if @encoded_content
        if overwrite
          @encoded_content = nil
          @liquid_hash = {}
          @current_key = 0
        else
          raise RuntimeError, "LiquidEncoder#encode called with overwrite set to false, but I have already encoded a string."
        end
      end

      # Encode data
      in_raw_block = false
      @encoded_content = content.gsub(/(\{\{.*?\}\})|(\{%.*?%\})/) do |m|
        # {% endraw %} means we stop the raw block. This tag should be encoded
        if m =~ /\{%\s*endraw\s*%\}/
          in_raw_block = false
        end

        gsubbed_string = if in_raw_block
          m
        else
          key = next_available_key
          @liquid_hash[key] = m
          encoded_tag(key)
        end

        # {% raw %} means we start a raw block. This tag will have been encoded
        if m =~ /\{%\s*raw\s*%\}/
          in_raw_block = true
        end

        gsubbed_string
      end
    end

    # Decode a string. Finds and replaces any liquid html tags with their original liquid content.
    #
    # content - the String to be decoded.
    #
    # Returns the decoded string.
    def decode(content)
      content.gsub(decoder_regexp) do |m|
        key = $1.to_i
        if @liquid_hash.has_key? key
          @liquid_hash[key]
        else
          m
        end
      end
    end

    # The LiquidEncoder tag for a given key
    #
    # key - the key for this tag
    #
    # Returns the liquid tag
    def encoded_tag(key)
      "<!--LIQUID-#{salt}-#{key}-->"
    end

    # A regexp to match all liquid keys for this encoder.
    def decoder_regexp
      @decoder_regexp ||= /<!--LIQUID-#{salt}-(\d+)-->/
    end

    # Finds any reserved keys (i.e. instances of the liquid encoding key) in a given content.
    #
    # content - the String to be scanned
    #
    # Returns an array of reserved keys
    def reserved_keys_for(content)
      content.scan(decoder_regexp).map{ |m| m[0] }
    end

    private
    # Returns the next available key. Keys start at 0 and increment.
    #
    # Returns the next key.
    def next_available_key
      k = @current_key
      @current_key += 1
      k
    end
  end
end