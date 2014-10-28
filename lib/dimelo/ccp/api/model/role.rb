module Dimelo::CCP
  class Role < Dimelo::CCP::API::Model

    attributes :id, :label, :team
    attributes :view_site, :edit_customization, :view_admin, :edit_grids, :send_private_message, :view_analytics, :view_identities, :view_advanced_admin, :configure_extensions, :configure_mobile

  end
end
