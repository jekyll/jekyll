RSpec.describe(Jekyll::Configuration) do
  let(:config) { described_class.from({}) }

  describe "#safe_load_file" do
    it "throws an InvalidFileFormat on a bad extension" do
      filename = "my_config.json"
      expect(-> { config.safe_load_file(filename) }).to raise_error(
        Jekyll::Errors::InvalidFileFormatError,
        "No parser for '#{filename}' is available. Use a .toml or .y(a)ml file instead."
      )
    end
  end

  describe "#read_config_file" do
    it "throws a FileNotFoundError if the file doesn't exist" do
      filename = "_config.yml"
      expect(-> { config.read_config_file(filename) }).to raise_error(
        Jekyll::Errors::FileNotFoundError,
        "The configuration file '#{filename}' could not be found."
      )
    end
  end

  describe "#check_config_is_hash!" do
    it "does not throw if the input is a hash" do
      expect(config.send(:check_config_is_hash!, {}, "_config.yml")).to eq(nil)
    end

    it "throws an InvalidConfigurationError if the input is not a hash" do
      filename = "_config.yml"
      expect(-> { config.send(:check_config_is_hash!, false, filename) }).to raise_error(
        Jekyll::Errors::InvalidConfigurationError,
        "The configuration file '#{filename}' is invalid: it is not a Hash."
      )
    end
  end
end
