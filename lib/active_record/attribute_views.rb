module ActiveRecord
  class AttributeView
    attr_accessor :attributes
    
    def initialize(*attributes)
      self.attributes = attributes
    end
    
    def get(record)
      load(*attributes.map { |attribute| record.send(attribute) })
    end
    
    def load(*values)
      raise NoMethodError, "Please implement the `load' method on your view class"
    end
    
    def set(record, input)
      parsed = Array(parse(input))
      record.attributes = Hash[*attributes.zip(parsed).flatten]
    end
    
    def parse(input)
      raise NoMethodError, "Please implement the `parse' method on your view class"
    end
  end
  
  # Attribute views translate between value object in your application and columns in your database. A value object
  # is basically any object that represents a value, for example an IP address or a rectangle. A database has a
  # limited number of values it can represent internally. In order to store value object we need some sort of
  # conversion from the value object to database columns. In order to read the value object we need a conversion
  # from columns to a value object.
  #
  # Note that attribute views are a really flexible concept and in some cases it's perfectly fine to use a string
  # as the value object. Later on we will look at an example of this.
  #
  # = Defining views
  #
  # In order to create an attribute view you need to create a class that takes care of the conversion between
  # column values and your value object. The easiest way to create a view class is by subclassing from
  # ActiveRecord::AttributeView and implementing two methods: <code>load</code> and <code>parse</code>.
  #
  # The <code>load</code> method receives the column values from the record and returns the value object. The
  # <code>parse</code> method receives the value object and returns a list of column values.
  #
  # Let's assume we want to describe a plot in the lots table with the following schema:
  #
  #   ActiveRecord::Schema.define do
  #     create_table :lots do |t|
  #       t.integer :price_in_cents
  #       t.integer :position_x
  #       t.integer :position_y
  #       t.integer :position_width
  #       t.integer :position_height
  #     end
  #   end
  #
  # In our application we're going to handle the position of the Lot very often so we want to access it through
  # a value object. We write the following value object to represent it as a rectangle:
  #
  #   class Rectangle
  #     attr_accessor :x1, :y1, :x2, :y2
  #
  #     def initialize(x1, y1, x2, y2)
  #       @x1, @y1, @x2, @y2 = x1, y1, x2, y2
  #     end
  #   end
  #
  #   class Lot < ActiveRecord::Base
  #     views :position, :as => RectangleView.new(:position_x, :position_y, :position_width, :position_height)
  #   end
  #
  #   class RectangleView < ActiveRecord::AttributeView
  #     def load(x, y, width, height)
  #       Rectangle.new(x, y, x + width, y + height)
  #     end
  #
  #     def parse(rectangle)
  #       [rectangle.x1, rectangle.y1, (rectangle.x2 - rectangle.x1), (rectangle.y2 - rectangle.y1)]
  #     end
  #   end
  module AttributeViews
    def views(name, options={})
      options.assert_valid_keys(:as)
      raise ArgumentError, "Please specify a view object with the :as option" unless options.has_key?(:as)
      
      view_name = "#{name}_view"
      
      define_method(view_name) do
        options[:as]
      end
      
      class_eval <<-READER_METHODS, __FILE__, __LINE__
        def #{name}                                       # def starts_at
          #{view_name}.get(self)                          #   starts_at_view.get(self)
        end                                               # end
      READER_METHODS
      
      class_eval <<-WRITER_METHODS, __FILE__, __LINE__
        def #{name}_before_type_cast                      # def starts_at_before_type_cast
          @#{name}_before_type_cast || #{name}            #   @starts_at_before_type_cast || starts_at
        end                                               # end
        
        def #{name}=(value)                               # def starts_at=(value)
          @#{name}_before_type_cast = value               #   @starts_at_before_type_cast = value
          #{view_name}.set(self, value)                   #   starts_at_view.set(self, value)
        end                                               # end
      WRITER_METHODS
    end
  end
end