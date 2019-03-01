# frozen_string_literal: true

module Spree
  class Address::StateNormalizer
    attr_reader :address
    delegate :state, :state_name, :country, to: :address

    def initialize(address)
      @address = address
    end

    def perform!
      normalize_state! if state.present?
      normalize_state_name! if state_name.present?
    end

    private

    def normalize_state!
      # discard the `state` when having a
      # country with no states
      if country.try(:states).blank?
        address.state = nil
      end
    end

    def normalize_state_name!
      return if country.blank?

      # discard the `state_name` when having a
      # valid `state` and country combo
      if state.present? && state.country == country
        address.state_name = nil
      end

      # set the state from the state name if the country contains
      # one with that name
      states_from_name = country.states.with_name_or_abbr(state_name)
      if states_from_name.size == 1
        address.state = states_from_name.first
        address.state_name = nil
      end
    end
  end
end
