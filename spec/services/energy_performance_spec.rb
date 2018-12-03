require 'rails_helper'

RSpec.describe EnergyPerformance, type: :model do
  let(:subject) { described_class.new('Flat 1', '123', 'ABC123') }

  context 'with a valid certificate' do
    before do
      stub_request(:get, %r{https:\/\/epc\.opendatacommunities\.org})
        .to_return(body: { rows: [{ foo: 'bar' }] }.to_json, headers: { content_type: 'application/json' })
    end

    it 'returns certificate data' do
      expect(subject.report).to eq('foo' => 'bar')
    end
  end

  context 'when there are no reports' do
    before do
      stub_request(:get, %r{https:\/\/epc\.opendatacommunities\.org})
        .to_return(body: { rows: [] }.to_json, headers: { content_type: 'application/json' })
    end

    it 'returns nil' do
      expect(subject.report).to be_nil
    end
  end

  context 'with an empty body' do
    before do
      stub_request(:get, %r{https:\/\/epc\.opendatacommunities\.org})
        .to_return(body: '', headers: { content_type: 'application/json' })
    end

    it 'returns nil' do
      expect(subject.report).to be_nil
    end
  end
end
