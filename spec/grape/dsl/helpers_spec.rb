require 'spec_helper'

module GrapeV0_14_0
  module DSL
    module HelpersSpec
      class Dummy
        include GrapeV0_14_0::DSL::Helpers

        def self.mod
          namespace_stackable(:helpers).first
        end
      end
    end

    module BooleanParam
      extend GrapeV0_14_0::API::Helpers

      params :requires_toggle_prm do
        requires :toggle_prm, type: Boolean
      end
    end

    describe Helpers do
      subject { Class.new(HelpersSpec::Dummy) }
      let(:proc) do
        lambda do |*|
          def test
            :test
          end
        end
      end

      describe '.helpers' do
        it 'adds a module with the given block' do
          expect(subject).to receive(:namespace_stackable).with(:helpers, kind_of(GrapeV0_14_0::DSL::Helpers::BaseHelper)).and_call_original
          expect(subject).to receive(:namespace_stackable).with(:helpers).and_call_original
          subject.helpers(&proc)

          expect(subject.mod.instance_methods).to include(:test)
        end

        it 'uses provided modules' do
          mod = Module.new

          expect(subject).to receive(:namespace_stackable).with(:helpers, kind_of(GrapeV0_14_0::DSL::Helpers::BaseHelper)).and_call_original
          expect(subject).to receive(:namespace_stackable).with(:helpers).and_call_original
          subject.helpers(mod, &proc)

          expect(subject.mod).to eq mod
        end

        context 'with an external file' do
          it 'sets Boolean as a Virtus::Attribute::Boolean' do
            subject.helpers BooleanParam
            expect(subject.mod::Boolean).to eq Virtus::Attribute::Boolean
          end
        end
      end
    end
  end
end
