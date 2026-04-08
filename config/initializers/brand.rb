# config/initializers/brand.rb
BRAND = Rails.application.config_for(:brand).freeze

module BrandHelper
  def brand_name
    BRAND['name'] || 'ChatUp'
  end

  def brand_primary_color
    BRAND['primary_color'] || '#1B4F72'
  end

  def brand_logo_path
    BRAND['logo_path'] || '/brand-assets/logo.svg'
  end
end

ActiveSupport.on_load(:action_view) { include BrandHelper }
ActiveSupport.on_load(:action_controller) { include BrandHelper }
