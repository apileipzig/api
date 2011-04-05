class AddHttpUserAgentColumnToRequestLogs < ActiveRecord::Migration
  def self.up
    add_column :request_logs, :user_agent, :string, :after => :ip
  end

  def self.down
    remove_column :request_logs, :user_agent
  end
end
