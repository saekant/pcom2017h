source "https://rubygems.org"

ruby file: ".ruby-version"

gem "rails", "~> 8.1.4"
# Modern asset pipeline (serves CSS, images and the small amount of JS this app uses)
gem "propshaft"
# PostgreSQL (Heroku Postgres)
gem "pg", "~> 1.5"
# Web server
gem "puma", ">= 6.0"
# Faster boot
gem "bootsnap", require: false
gem "tzinfo-data", platforms: %i[ windows jruby ]

group :development, :test do
  gem "debug", platforms: %i[ mri windows ], require: "debug/prelude"
  # Security checks (also run in CI)
  gem "bundler-audit", require: false
  gem "brakeman", require: false
end
