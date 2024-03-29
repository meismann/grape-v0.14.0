module GrapeV0_14_0
  module Validations
    require 'grape_v0_14_0/validations/validators/multiple_params_base'
    class AllOrNoneOfValidator < MultipleParamsBase
      def validate!(params)
        super
        if scope_requires_params && only_subset_present
          fail GrapeV0_14_0::Exceptions::Validation, params: all_keys, message_key: :all_or_none
        end
        params
      end

      private

      def only_subset_present
        scoped_params.any? { |resource_params| keys_in_common(resource_params).length > 0 && keys_in_common(resource_params).length < attrs.length }
      end
    end
  end
end
