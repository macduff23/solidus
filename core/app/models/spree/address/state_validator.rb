# frozen_string_literal: true

module Spree
  class Address::StateValidator
    attr_reader :address
    delegate :state, :state_name, :country, to: :address

    def initialize(address)
      @address = address
    end

    def perform!
      return unless state_required?

      validate_not_blank!
      validate_matches_country! if state.present?
    end

    private

    def validate_not_blank!
      if state.blank? && state_name.blank?
        address.errors.add(:state, :blank)
      end
    end

    def validate_matches_country!
      if state.country != country
        address.errors.add(:state, :does_not_match_country)
      end
    end

    # Don't require a state if disabled at config level or
    # the associated country doesn't require states
    def state_required?
      Spree::Config[:address_requires_state] &&
        country_requires_states?
    end

    def country_requires_states?
      # default to `true` if country not present
      return true if country.blank?
      country.states_required
    end
  end
end
