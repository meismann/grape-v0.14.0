require 'spec_helper'

describe GrapeV0_14_0::API::Helpers do
  module NestedHelpersSpec
    module HelperMethods
      extend GrapeV0_14_0::API::Helpers
      def current_user
        @current_user ||= params[:current_user]
      end
    end

    class Nested < GrapeV0_14_0::API
      resource :level1 do
        helpers HelperMethods

        get do
          current_user
        end

        resource :level2 do
          get do
            current_user
          end
        end
      end
    end

    class Main < GrapeV0_14_0::API
      mount Nested
    end
  end

  subject do
    NestedHelpersSpec::Main
  end

  def app
    subject
  end

  it 'can access helpers from a mounted resource' do
    get '/level1', current_user: 'hello'
    expect(last_response.body).to eq('hello')
  end

  it 'can access helpers from a mounted resource in a nested resource' do
    get '/level1/level2', current_user: 'world'
    expect(last_response.body).to eq('world')
  end
end
