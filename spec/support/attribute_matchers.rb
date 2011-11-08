module AttributeMatchers
  RSpec::Matchers.define :persist_attribute do |attribute|
    match do |instance|
      @attribute = attribute
      @instance = instance
      responds_to_methods &&
      instance_valid &&
        write_attribute &&
        save &&
        reload &&
        read_attribute
    end

    failure_message { @failure_message }

    chain :with_value do |value|
      @value = value
    end

    chain :embedded_within do |parent_association|
      @parent_association = parent_association
    end

    def instance_valid
      assert(@instance.valid?) { "Can't test that #{@attribute} persists without a valid instance" }
    end

    def responds_to_methods
      required_methods = [:valid?, :save, :id, @attribute, :"#{@attribute}="]
      missing_methods = required_methods.select { |method| !@instance.respond_to?(method) }
      assert(missing_methods.empty?) { "Missing required methods: #{missing_methods.inspect}" }
    end

    def write_attribute
      @instance.send(:"#{@attribute}=", value)
      true
    end

    def save
      assert(@instance.save) { "Couldn't save: #{@instance.errors.full_messages.inspect}" }
    end

    def reload
      if @parent_association
        association = @instance.class.associations[@parent_association.to_s]
        parent = @instance.send(@parent_association)
        reloaded_parent = parent.class.find(parent._id)
        @instance = reloaded_parent.
          send(association.options.inverse_of).
          where(:_id => @instance._id).
          first
      else
        @instance = @instance.class.find(@instance._id)
      end
      true
    end

    def read_attribute
      actual_value = @instance.send(@attribute)
      assert(actual_value == value) do
        "After reloading, got #{actual_value.inspect} instead of #{value.inspect} for #{@attribute}"
      end
    end

    def assert(condition)
      if condition
        true
      else
        @failure_message = yield
        false
      end
    end

    def value      
      if @value.is_a?(FalseClass)
        @value
      else
        @value ||= 'test value'
      end
    end
  end

  RSpec::Matchers.define :delegate do |delegated_method|
    chain :to do |target_method|
      @target_method = target_method
    end

    chain :as do |method_on_target|
      @method_on_target = method_on_target
    end

    chain :with_arguments do |args|
      @args = args
    end

    match do |instance|
      extend Mocha::API

      @instance = instance
      @args ||= []
      return_value = 'stubbed return value'
      method_on_target = @method_on_target || delegated_method
      stubbed_target = stub('stubbed_target', method_on_target => return_value)
      @instance.stubs(@target_method => stubbed_target)
      begin
        @instance.send(delegated_method, *@args).should == return_value
      rescue NoMethodError
        false
      end
    end

    failure_message do
      if Class === @instance
        message = "expected #{@instance.name} "
        prefix = '.'
      else
        message = "expected #{@instance.class.name} "
        prefix = '#'
      end
      message << "to delegate #{prefix}#{delegated_method} to #{prefix}#{@target_method}"
      if @method_on_target
        message << ".#{@method_on_target}"
      end
      message
    end
  end

  RSpec::Matchers.define :fulfill_resque_guidelines do
    match do |instance|
      extend Mocha::API

      @instance = instance
      @instance_class = instance.class

      queue_name.should_not be_nil
      allows_a_method_be_performed
    end

    failure_message do
      if queue_name.nil?
        "missing a queue"
      else
        "method cannot be performed"
      end
    end

    def allows_a_method_be_performed
      method_to_perform = "method_#{Time.now.to_i}"

      Mocha::Configuration.allow(:stubbing_non_existent_method) do
        @instance.stubs(method_to_perform)
        @instance_class.stubs(:find => @instance)

        @instance_class.perform(@instance.id, method_to_perform)

        @instance.should have_received(method_to_perform)
        @instance_class.should have_received(:find).with(@instance.id)
      end
    end

    def queue_name
      queue = @instance_class.instance_variable_get("@queue")
      queue ||= @instance_class.send("queue") if @instance_class.public_method_defined?("queue")
      queue
    end
  end

  RSpec::Matchers.define :have_mongoid_timestamps do
    match do |instance|
      @instance = instance
      @instance.save
      responds_to_timestamp_methods &&
        populates_timestamp_fields &&
        updates_updated_at_field
    end

    failure_message { @failure_message }

    def responds_to_timestamp_methods
      required_methods = [:created_at, :created_at=, :updated_at, :updated_at=]
      missing_methods = required_methods.select { |method| !@instance.respond_to?(method) }
      assert(missing_methods.empty?) { "Missing required methods: #{missing_methods.inspect}" }
    end

    def populates_timestamp_fields
      new_record = @instance.dup
      new_record.created_at = nil
      new_record.updated_at = nil
      new_record.save
      new_record.reload
      assert(new_record.created_at && new_record.updated_at) { "created_at and updated_at are not populated after a save" }
    end

    def updates_updated_at_field
      old_value = @instance.updated_at
      Timecop.freeze do
        @instance.save
        @instance.reload
        assert(@instance.updated_at == Time.now) { "updated_at did not update after saving" }
      end
    end

    def assert(condition)
      if condition
        true
      else
        @failure_message = yield
        false
      end
    end

  end


  RSpec::Matchers.define :have_changed do |attribute|
    match do |subject|
      subject.attribute_changed?(attribute.to_s)
    end
  end
end
