require 'rubygems'

# Set up gems listed in the Gemfile.
ENV['BUNDLE_GEMFILE'] ||= File.expand_path('../../Gemfile', __FILE__)

require 'bundler/setup' if File.exists?(ENV['BUNDLE_GEMFILE'])

# Rails 3.0 emits an obsolete PostgreSQL session setting ('panic') that
# PostgreSQL 15+ rejects. Patch the adapter source before Rails initializes.
if ENV['RAILS_ENV'] == 'production'
  begin
    spec = Gem::Specification.find_by_name('activerecord', '3.0.20')
    adapter_path = File.join(spec.full_gem_path, 'lib/active_record/connection_adapters/postgresql_adapter.rb')
    if File.file?(adapter_path)
      source = File.read(adapter_path)
      patched = source.gsub("SET client_min_messages TO 'panic'", "SET client_min_messages TO 'error'")
      File.open(adapter_path, 'w') { |io| io.write(patched) } if patched != source
    end
  rescue StandardError => e
    warn "PostgreSQL compatibility patch skipped: #{e.message}"
  end
end
