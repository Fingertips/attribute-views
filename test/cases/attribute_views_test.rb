require File.expand_path('../../test_helper.rb', __FILE__)

class AttributeViewsClassmethodsTest < ActiveSupport::TestCase
  test "views should raise argument error about invalid option keys" do
    begin
      Event.send(:views, :formatted_fee, :as => FeeFormatter.new(:fee_in_cents), :invalid => :should_raise)
    rescue ArgumentError => e
      assert_match /invalid/, e.message
    else
      fail 'Should raise an ArgumentError'
    end
  end
  
  test "views should raise argument error about missing :as option" do
    begin
      Event.send(:views, :formatted_fee)
    rescue ArgumentError => e
      assert_equal "Please specify a view object with the :as option", e.message
    else
      fail 'Should raise an ArgumentError'
    end
  end
  
  test "views should define a reader method for the view object" do
    assert_respond_to Event.new, :starts_at_view
  end
  
  test "views should define a reader method for the value object" do
    assert_respond_to Event.new, :starts_at
  end
  
  test "views should define a reader method for the value object before type cast" do
    assert_respond_to Event.new, :starts_at_before_type_cast
  end
  
  test "views should define a writer method for the value object" do
    assert_respond_to Event.new, :starts_at=
  end
end

class AttributeViewsFunctionTest < ActiveSupport::TestCase
  def setup
    @input = '24 May 23:00'
    @value = "24 May 2009 23:00"
    
    @date = Date.new(2009, 5, 24)
    @time = Time.parse('23:00')
    @event = Event.new(:start_date => @date, :start_time => @time)
  end
  
  test "view object reader should return the view object" do
    assert_kind_of CompositeDatetime, @event.starts_at_view
  end
  
  test "view object reader should always return the same view object" do
    assert_equal Event.new.starts_at_view, Event.new.starts_at_view
  end
  
  test "value object reader method should return the value object" do
    @event.starts_at_view.expects(:load).with(@date, @time).returns(@value)
    assert_equal @value, @event.starts_at
  end
  
  test "value object before type cast should be the value object when nothing was set" do
    @event.starts_at_view.stubs(:load).with(@date, @time).returns(@value)
    assert_equal @value, @event.starts_at_before_type_cast
  end
  
  test "value object before type cast should be the input when it was just set" do
    @event.starts_at = @input
    assert_equal @input, @event.starts_at_before_type_cast
  end
  
  test "value object writer should set attributes on the record" do
    event = Event.new
    event.starts_at_view.stubs(:parse).with(@input).returns([@date, @time])
    
    event.starts_at = @input
    assert_equal @date, event.start_date
    assert_equal @time, event.start_time
  end
  
  test "value object writer should update attributes on the record" do
    date = Date.new(2009, 12, 31)
    time = Time.parse('01:00')
    input = '31 12 01:00'
    @event.starts_at_view.stubs(:parse).with(input).returns([date, time])
    
    @event.starts_at = input
    assert_equal date, @event.start_date
    assert_equal time, @event.start_time
  end
end