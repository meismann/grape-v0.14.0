require 'spec_helper'

describe GrapeV0_14_0::Middleware::Versioner do
  let(:klass) { GrapeV0_14_0::Middleware::Versioner }

  it 'recognizes :path' do
    expect(klass.using(:path)).to eq(GrapeV0_14_0::Middleware::Versioner::Path)
  end

  it 'recognizes :header' do
    expect(klass.using(:header)).to eq(GrapeV0_14_0::Middleware::Versioner::Header)
  end

  it 'recognizes :param' do
    expect(klass.using(:param)).to eq(GrapeV0_14_0::Middleware::Versioner::Param)
  end

  it 'recognizes :accept_version_header' do
    expect(klass.using(:accept_version_header)).to eq(GrapeV0_14_0::Middleware::Versioner::AcceptVersionHeader)
  end
end
