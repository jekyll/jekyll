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
        custom_options = {
          "config"  => %w(_config.yml _development.yml),
          "serving" => true,
          "watch"   => false # for not having guard output when running the tests
        }
        allow(SafeYAML).to receive(:load_file).and_return({})
        allow(Jekyll::Commands::Build).to receive(:build).and_return("")

        expect(Jekyll::Commands::Serve).to receive(:process).with(custom_options)
        @merc.execute(:serve, { "config" => %w(_config.yml _development.yml),
                                "watch"  => false })
      end

      context "verbose" do
        should "debug when verbose" do
          assert_equal custom_opts({ "verbose" => true })[:Logger].level, 5
        end

        should "warn when not verbose" do
          assert_equal custom_opts({})[:Logger].level, 3
        end
      end

      context "enabling ssl" do
        should "raise if enabling without key or cert" do
          assert_raises RuntimeError do
            custom_opts({
              "ssl_key" => "foo"
            })
          end

          assert_raises RuntimeError do
            custom_opts({
              "ssl_key" => "foo"
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
            "ssl_key"    => "bar"
          })

          assert result[:SSLEnable]
          assert_equal result[:SSLPrivateKey ], "c2"
          assert_equal result[:SSLCertificate], "c1"
        end
      end
    end
  end
end
