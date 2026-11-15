class ApplicationController < ActionController::Base
  # Unknown records (e.g. a material_id that does not exist) are shown as a plain 404 page.
  rescue_from ActiveRecord::RecordNotFound, with: :render_not_found

  private

  def render_not_found
    render file: Rails.public_path.join("404.html"), status: :not_found, layout: false
  end
end
