module Api
  module Assertions

    def assert_status(expected, response=last_response)
      assert_equal expected, response.status, "Expected a #{expected} status, got #{response.status} instead"
    end

    def assert_body(json_string=last_response.body, &block)
      assert_json(json_string, &block)
    end

    def assert_error_on(attribute, record)
      record.valid?
      assert !record.errors[attribute].empty?, "Expected record: #{record.inspect} to have errors on attribute: #{attribute} when set to #{record.send(attribute)}"
    end

  end

end
