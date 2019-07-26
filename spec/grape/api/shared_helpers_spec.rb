require 'spec_helper'

describe GrapeV0_14_0::API::Helpers do
  subject do
    shared_params = Module.new do
      extend GrapeV0_14_0::API::Helpers

      params :pagination do
        optional :page, type: Integer
        optional :size, type: Integer
      end
    end

    Class.new(GrapeV0_14_0::API) do
      helpers shared_params
      format :json

      params do
        use :pagination
      end
      get do
        declared(params, include_missing: true)
      end
    end
  end

  def app
    subject
  end

  it 'defines parameters' do
    get '/'
    expect(last_response.status).to eq 200
    expect(last_response.body).to eq({ page: nil, size: nil }.to_json)
  end
end
