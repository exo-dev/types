FactoryGirl.define do
  factory :device_property, aliases: %w(device_status) do
    property_id { FactoryGirl.create(:property).id }
    id          { property_id}
    value       'off'
  end

  factory :device_intensity, parent: :device_property do
    property_id { FactoryGirl.create(:property).id }
    id          { property_id}
    value       '0'
  end
end
