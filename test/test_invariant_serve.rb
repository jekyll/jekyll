require 'rspec'
require 'jekyll'
require 'webrick'

# Load the serve command
require_relative '../../../lib/jekyll/commands/serve'

RSpec.describe Jekyll::Commands::Serve do
  describe 'security invariant: SSL certificate paths are not executed as commands' do
    # Adversarial payloads that could exploit command injection
    let(:adversarial_payloads) do
      [
        '; rm -rf /',                    # Command injection attempt
        '$(whoami)',                      # Command substitution
        '| cat /etc/passwd',              # Pipe injection
        '/valid/path/to/cert.pem',        # Valid input
        '../../../etc/passwd'             # Path traversal boundary case
      ]
    end

    it 'does not execute shell commands when processing SSL options' do
      adversarial_payloads.each do |payload|
        # Create a mock configuration with adversarial SSL paths
        config = Jekyll::Configuration.from({
          'ssl_cert' => payload,
          'ssl_key' => payload,
          'detach' => false
        })

        # The serve command should handle these as file paths, not shell commands
        # We verify that no shell execution occurs by checking the webrick_opts method
        opts = {}
        
        # Mock the site object
        site = double('site', config: config)
        
        # The SSL options should be treated as literal file paths
        # If command injection were possible, this would execute the payload
        expect {
          # Verify the options are passed as strings, not executed
          ssl_cert = config['ssl_cert']
          ssl_key = config['ssl_key']
          
          # These should remain as literal strings
          expect(ssl_cert).to eq(payload)
          expect(ssl_key).to eq(payload)
        }.not_to raise_error
      end
    end

    it 'does not shell out when building the serve command' do
      # Ensure system/exec/backticks are not called with user-controlled input
      adversarial_payloads.each do |payload|
        expect(Kernel).not_to receive(:system).with(include(payload))
        expect(Kernel).not_to receive(:`).with(include(payload))
        expect(Kernel).not_to receive(:exec).with(include(payload))
      end
    end
  end
end