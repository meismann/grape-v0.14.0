module GrapeV0_14_0
  module Validations
    require 'grape_v0_14_0/validations/validators/multiple_params_base'
    class AtLeastOneOfValidator < MultipleParamsBase
      def validate!(params)
        super
        if scope_requires_params && no_exclusive_params_are_present
          fail GrapeV0_14_0::Exceptions::Validation, params: all_keys, message_key: :at_least_one
        end
        params
      end

      private

      def no_exclusive_params_are_present
        scoped_params.any? { |resource_params| keys_in_common(resource_params).empty? }
      end
    end
  end
end
