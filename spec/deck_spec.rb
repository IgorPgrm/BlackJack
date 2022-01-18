require 'rspec'
require_relative '../deck.rb'

RSpec.describe Deck do
  subject(:deck) { described_class.new }
  
  context 'when initialized without params' do
    it { expect(deck.cards.size).to eq(52*4) }
  end

  context 'when new_deck' do
    let(:card) { double('Card', name: 2, cost: 2, suit: '♥') }
    before { deck.new_deck(1) }

    it { expect(deck.cards.first).to eq(card) }
  end
end
