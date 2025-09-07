# spec/models/user_spec.rb
require 'rails_helper'

describe User do
  subject { described_class.new(name: 'Test User', email: 'test@example.com', api_key: 'abc123') }

  it 'is valid with valid attributes' do
    expect(subject).to be_valid
  end

  it 'is invalid without a name' do
    subject.name = nil
    expect(subject).to_not be_valid
  end

  it 'is invalid without an email' do
    subject.email = nil
    expect(subject).to_not be_valid
  end

  it 'is invalid without an api_key' do
    subject.api_key = nil
    expect(subject).to_not be_valid
  end

  it 'checks for uniqueness of email' do
    described_class.create!(name: 'Other', email: 'test@example.com', api_key: 'xyz')
    expect(subject).to_not be_valid
  end

  it 'checks for uniqueness of api_key' do
    described_class.create!(name: 'Other', email: 'other@example.com', api_key: 'abc123')
    expect(subject).to_not be_valid
  end

  describe '#active_key?' do
    it 'returns true if expires_at is in the future' do
      subject.expires_at = 1.hour.from_now
      expect(subject.active_key?).to be true
    end

    it 'returns false if expires_at is in the past' do
      subject.expires_at = 1.hour.ago
      expect(subject.active_key?).to be false
    end
  end
end
