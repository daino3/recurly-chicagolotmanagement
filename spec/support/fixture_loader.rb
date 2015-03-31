module FixtureLoader
  def load_fixture(filename)
    path = "#{APP_ROOT}/spec/fixtures/#{filename}"
    if File.extname(filename).include?('yml')
      yaml_hash = YAML.load_file(path)
      Hashie::Mash.new(yaml_hash)
    else
      File.open(path).read
    end
  end
end
