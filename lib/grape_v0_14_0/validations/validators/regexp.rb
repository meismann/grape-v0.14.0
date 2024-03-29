module GrapeV0_14_0
  module Validations
    class RegexpValidator < Base
      def validate_param!(attr_name, params)
        return unless params.key?(attr_name) && !params[attr_name].nil? && !(params[attr_name].to_s =~ @option)
        fail GrapeV0_14_0::Exceptions::Validation, params: [@scope.full_name(attr_name)], message_key: :regexp
      end
    end
  end
end
