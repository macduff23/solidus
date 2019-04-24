# frozen_string_literal: true

json.cache! [I18n.locale, current_pricing_options, variant] do
  json.(variant, *variant_attributes)
  json.price(variant.price_for(current_pricing_options).try(:to_d))
  json.display_price(variant.price_for(current_pricing_options).to_s)
  json.options_text(variant.options_text)
  json.track_inventory(variant.should_track_inventory?)
  json.in_stock(variant.in_stock?)
  json.is_backorderable(variant.is_backorderable?)

  # We can't represent Float::INFINITY in JSON
  # Under JSON this woulb be NULL
  # Under oj this would error
  json.total_on_hand(variant.should_track_inventory? ? variant.total_on_hand : nil)

  json.is_destroyed(variant.destroyed?)
  json.option_values(variant.option_values) do |option_value|
    json.(option_value, *option_value_attributes)
  end
  json.images(variant.gallery.images) do |image|
    json.partial!("spree/api/images/image", image: image)
  end
end
