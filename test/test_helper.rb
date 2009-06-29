require 'rubygems' rescue nil

require 'active_support'
require 'active_record'

require 'test/unit'
require 'active_support/test_case'

require 'mocha'

plugin_dir = File.expand_path('../../', __FILE__)
$:.unshift(File.join(plugin_dir, 'lib'), File.join(plugin_dir, 'rails'))
require 'init'

test_dir = File.expand_path('../', __FILE__)
$:.unshift(File.join(test_dir, 'cases'), File.join(test_dir, 'models'))
require 'fee_formatter'
require 'composite_datetime'
require 'event'

ActiveRecord::Base.establish_connection(:adapter => 'sqlite3', :database => ':memory:')

ActiveRecord::Migration.verbose = false
ActiveRecord::Schema.define(:version => 1) do
  create_table :events, :force => true do |t|
    t.integer :fee_in_cents
    t.date :start_date
    t.time :start_time
  end
end
