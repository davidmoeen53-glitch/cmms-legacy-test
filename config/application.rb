require File.expand_path('../boot', __FILE__)

require 'rails/all'

# Compatibility patch for Rails 3.0.20 against modern PostgreSQL.
# Rails 3 temporarily sets client_min_messages to the obsolete value "panic"
# while enabling standard_conforming_strings. PostgreSQL 15+ rejects it.
require 'active_record/connection_adapters/postgresql_adapter'
module ActiveRecord
  module ConnectionAdapters
    class PostgreSQLAdapter

      # PostgreSQL 12+ removed pg_attrdef.adsrc. Use pg_get_expr instead.
      def column_definitions(table_name)
        query <<-SQL
          SELECT a.attname,
                 format_type(a.atttypid, a.atttypmod),
                 pg_get_expr(d.adbin, d.adrelid),
                 a.attnotnull
          FROM pg_attribute a
          LEFT JOIN pg_attrdef d
            ON a.attrelid = d.adrelid AND a.attnum = d.adnum
          WHERE a.attrelid = '#{quote_table_name(table_name)}'::regclass
            AND a.attnum > 0
            AND NOT a.attisdropped
          ORDER BY a.attnum
        SQL
      end

      # Old Rails 3 migration code can rescue catalog/session-setting errors inside
      # a PostgreSQL transaction, leaving the transaction aborted on PostgreSQL 15+.
      # Run legacy migrations without wrapping each migration in one DDL transaction.
      def supports_ddl_transactions?
        false
      end

      def set_standard_conforming_strings
        old, self.client_min_messages = client_min_messages, 'error'
        execute('SET standard_conforming_strings = on') rescue nil
      ensure
        self.client_min_messages = old
      end
    end
  end
end

# If you have a Gemfile, require the gems listed there, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(:default, Rails.env) if defined?(Bundler)

module Cmms
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Custom directories with classes and modules you want to be autoloadable.
    config.autoload_paths += %W(#{Rails.root}/app/modules)

    # Only load the plugins named here, in the order given (default is alphabetical).
    # :all can be used as a placeholder for all plugins not explicitly named.
    # config.plugins = [ :exception_notification, :ssl_requirement, :all ]

    # Activate observers that should always be running.
    # config.active_record.observers = :cacher, :garbage_collector, :forum_observer

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    config.time_zone = 'Bangkok'

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    # config.i18n.default_locale = :de

    # JavaScript files you want as :defaults (application.js is always included).
    # config.action_view.javascript_expansions[:defaults] = %w(jquery rails)

    # Configure the default encoding used in templates for Ruby 1.9.
    config.encoding = "utf-8"

    # Configure sensitive parameters which will be filtered from the log file.
    config.filter_parameters += [:password]
  end
end
