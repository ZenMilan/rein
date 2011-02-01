module RC
  module Presence
    include ActiveRecord::ConnectionAdapters::Quoting

    def add_presence_constraint(table, attribute)
      name       = "#{table}_#{attribute}"
      conditions = "#{attribute} !~ '^\s*$'"
      execute("ALTER TABLE #{table} ADD CONSTRAINT #{name} CHECK (#{conditions})")
    end
  end
end
