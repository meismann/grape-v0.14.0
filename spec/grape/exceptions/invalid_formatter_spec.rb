# encoding: utf-8
require 'spec_helper'

describe GrapeV0_14_0::Exceptions::InvalidFormatter do
  describe '#message' do
    let(:error) do
      described_class.new(String, 'xml')
    end

    it 'contains the problem in the message' do
      expect(error.message).to include(
        'cannot convert String to xml'
      )
    end
  end
end
