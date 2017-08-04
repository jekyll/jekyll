# frozen_string_literal: true

require "webrick"
require "mercenary"
require "helper"
require "openssl"

class TestCommandsServe < JekyllUnitTest
  def custom_opts(what)
    @cmd.send(
      :webrick_opts, what
    )
  end

  context "with a program" do
    setup do
      @merc = nil
      @cmd = Jekyll::Commands::Serve
      Mercenary.program(:jekyll) do |p|
        @merc = @cmd.init_with_program(
          p
        )
      end
      Jekyll.sites.clear
      allow(SafeYAML).to receive(:load_file).and_return({})
      allow(Jekyll::Commands::Build).to receive(:build).and_return("")
    end
    teardown do
      Jekyll.sites.clear
    end

    should "label itself" do
      assert_equal(
        @merc.name, :serve
      )
    end

    should "have aliases" do
      assert_includes @merc.aliases, :s
      assert_includes @merc.aliases, :server
    end

    should "have a description" do
      refute_nil(
        @merc.description
      )
    end

    should "have an action" do
      refute_empty(
        @merc.actions
      )
    end

    should "not have an empty options set" do
      refute_empty(
        @merc.options
      )
    end

    context "with custom options" do
      should "create a default set of mimetypes" do
        refute_nil custom_opts({})[
          :MimeTypes
        ]
      end

      should "use user destinations" do
        assert_equal "foo", custom_opts({ "destination" => "foo" })[
          :DocumentRoot
        ]
      end

      should "use user port" do
        # WHAT?!?!1 Over 9000? That's impossible.
        assert_equal 9001, custom_opts({ "port" => 9001 })[
          :Port
        ]
      end

      should "use empty directory index list when show_dir_listing is true" do
        opts = { "show_dir_listing" => true }
        assert custom_opts(opts)[:DirectoryIndex].empty?
      end

      should "keep config between build and serve" do
        options = {
          "config"  => %w(_config.yml _development.yml),
          "serving" => true,
          "watch"   => false, # for not having guard output when running the tests
          "url"     => "http://localhost:4000",
        }
        config = Jekyll::Configuration.from(options)

        allow(Jekyll::Command).to(
          receive(:configuration_from_options).with(options).and_return(config)
        )
        allow(Jekyll::Command).to(
          receive(:configuration_from_options).with(config).and_return(config)
        )

        expect(Jekyll::Commands::Build).to(
          receive(:process).with(config).and_call_original
        )
        expect(Jekyll::Commands::Serve).to receive(:process).with(config)
        @merc.execute(:serve, options)
      end

      context "in development environment" do
        setup do
          expect(Jekyll).to receive(:env).and_return("development")
          expect(Jekyll::Commands::Serve).to receive(:start_up_webrick)
        end
        should "set the site url by default to `http://localhost:4000`" do
          @merc.execute(:serve, { "watch" => false, "url" => "https://jekyllrb.com/" })

          assert_equal 1, Jekyll.sites.count
          assert_equal "http://localhost:4000", Jekyll.sites.first.config["url"]
        end

        should "take `host`, `port` and `ssl` into consideration if set" do
          @merc.execute(:serve, {
            "watch"    => false,
            "host"     => "example.com",
            "port"     => "9999",
            "url"      => "https://jekyllrb.com/",
            "ssl_cert" => "foo",
            "ssl_key"  => "bar",
          })

          assert_equal 1, Jekyll.sites.count
          assert_equal "https://example.com:9999", Jekyll.sites.first.config["url"]
        end
      end

      context "not in development environment" do
        should "not update the site url" do
          expect(Jekyll).to receive(:env).and_return("production")
          expect(Jekyll::Commands::Serve).to receive(:start_up_webrick)
          @merc.execute(:serve, { "watch" => false, "url" => "https://jekyllrb.com/" })

          assert_equal 1, Jekyll.sites.count
          assert_equal "https://jekyllrb.com/", Jekyll.sites.first.config["url"]
        end
      end

      context "verbose" do
        should "debug when verbose" do
          assert_equal custom_opts({ "verbose" => true })[:Logger].level, 5
        end

        should "warn when not verbose" do
          assert_equal custom_opts({})[:Logger].level, 3
        end
      end

      context "enabling SSL" do
        should "raise if enabling without key or cert" do
          assert_raises RuntimeError do
            custom_opts({
              "ssl_key" => "foo",
            })
          end

          assert_raises RuntimeError do
            custom_opts({
              "ssl_key" => "foo",
            })
          end
        end

        should "allow SSL with a key and cert" do
          expect(OpenSSL::PKey::RSA).to receive(:new).and_return("c2")
          expect(OpenSSL::X509::Certificate).to receive(:new).and_return("c1")
          allow(File).to receive(:read).and_return("foo")

          result = custom_opts({
            "ssl_cert"   => "foo",
            "source"     => "bar",
            "enable_ssl" => true,
            "ssl_key"    => "bar",
          })

          assert result[:SSLEnable]
          assert_equal result[:SSLPrivateKey ], "c2"
          assert_equal result[:SSLCertificate], "c1"
        end
      end
    end

    should "read `configuration` only once" do
      allow(Jekyll::Commands::Serve).to receive(:start_up_webrick)

      expect(Jekyll).to receive(:configuration).once.and_call_original
      @merc.execute(:serve, { "watch" => false })
    end
  end
end
