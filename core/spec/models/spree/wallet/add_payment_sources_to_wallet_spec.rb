# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Spree::Wallet::AddPaymentSourcesToWallet, type: :model do
  let(:order) { create(:order_ready_to_complete) }

  describe '#add_to_wallet' do
    subject { described_class.new(order) }

    it 'saves the payment source and calls make_default' do
      expect(subject).to receive(:make_default)
      subject.add_to_wallet
      expect(order.user.wallet.wallet_payment_sources.count).to eq(1)
    end
  end

  describe '#make_default' do
    subject(:call) { -> { described_class.new(order).make_default } }

    let(:payment) { create(:payment) }

    before do
      order.user.wallet.add(payment.source)
    end

    it 'makes the user payment source as default' do
      subject.call
      expect(order.user.wallet.wallet_payment_sources.any?(&:default)).to be_truthy
    end
  end
end
