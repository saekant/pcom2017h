# Content Security Policy: the browser only runs scripts served by this site
# (no inline <script>, no eval), and only loads images/CSS from this site.
# Inline style="..." attributes are still allowed because the original page
# layout (and the chart library) relies on them.
Rails.application.configure do
  config.content_security_policy do |policy|
    policy.default_src :self
    policy.script_src  :self
    policy.style_src   :self, :unsafe_inline
    policy.img_src     :self, :data
    policy.font_src    :self
    policy.connect_src :self
    policy.object_src  :none
    policy.base_uri    :self
    policy.form_action :self
    policy.frame_ancestors :self
  end
end
