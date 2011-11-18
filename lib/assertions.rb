module Api
  module Assertions

    def assert_status(expected, response=last_response)
      assert_equal expected, response.status, "Expected a #{expected} status, got #{response.status} instead"
    end

    def assert_body(json_string=last_response.body, &block)
      assert_json(json_string, &block)
    end

  end

end
