Mongoid::Document::ClassMethods.class_eval do
  def columns
    fields.values
  end
end
require 'factory_girl/step_definitions'
