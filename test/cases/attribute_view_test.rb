require File.expand_path('../../test_helper.rb', __FILE__)

class AttributeViewTest < ActiveSupport::TestCase
  def setup
    @view = ActiveRecord::AttributeView.new(:start_date, :start_time)
  end
  
  test "view stores the attributes it composes" do
    assert_equal [:start_date, :start_time], @view.attributes
  end
  
  test "view gets a value object using a record" do
    date = Date.new(2009, 5, 24)
    time = Time.parse('23:00')
    event = Event.new(:start_date => date, :start_time => time)
    value = mock('Value')
    
    @view.expects(:load).with(date, time).returns(value)
    assert_equal value, @view.get(event)
  end
  
  test "view warns the programmer to inplement the load method" do
    begin
      @view.load
    rescue NoMethodError => e
      assert_equal "Please implement the `load' method on your view class", e.message
    else
      fail 'Should raise a NoMethodError'
    end
  end
  
  test "view sets a value object on a record" do
    date = Date.new(2009, 5, 24)
    time = Time.parse('23:00')
    event = Event.new
    input = '24 5 23:00'
    
    @view.stubs(:parse).returns([date, time])
    @view.set(event, input)
    
    assert_equal date, event.start_date
    assert_equal time, event.start_time
  end
  
  test "view warns the programmer to inplement the parse method" do
    begin
      @view.parse('24 5 23:00')
    rescue NoMethodError => e
      assert_equal "Please implement the `parse' method on your view class", e.message
    else
      fail 'Should raise a NoMethodError'
    end
  end
end