# Rails 3.0's PostgreSQL adapter uses the historical value "panic" for
# client_min_messages. Modern PostgreSQL no longer accepts that value.
# Keep the application behavior unchanged while mapping only that obsolete
# session setting to the modern equivalent "error".
if defined?(ActiveRecord::ConnectionAdapters::PostgreSQLAdapter)
  adapter = ActiveRecord::ConnectionAdapters::PostgreSQLAdapter
  if adapter.const_defined?(:CLIENT_MIN_MESSAGES)
    adapter.send(:remove_const, :CLIENT_MIN_MESSAGES)
    adapter.const_set(:CLIENT_MIN_MESSAGES, 'error')
  end
end
