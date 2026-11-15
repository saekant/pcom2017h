# PCoM-DB

**Protein Co-Migration Database for photosynthetic organisms**
https://pcomdb.lowtem.hokudai.ac.jp/

PCoM-DB shows protein migration profiles across BN-PAGE gel slices (emPAI from
LC-MS/MS) so that protein complexes containing a protein of interest can be predicted.

## Stack

| | |
|---|---|
| Framework | Ruby on Rails 8.1 (Ruby 3.4) |
| Database | PostgreSQL (Heroku Postgres) – existing tables, no migrations are run |
| Hosting | Heroku (deploys automatically from `master`) |
| Front end | Plain CSS + a small vanilla JavaScript file (`app/assets/javascripts/pcom.js`) |
| Chart | Highcharts (`vendor/assets/javascripts/highcharts.js`) |

## Project layout

- `app/controllers/proteins_controller.rb` – all pages (URLs are unchanged from the original site)
- `app/models/` – `Organism`, `Material`, `Materialweight`, `Protein`, `Msresult`
- `app/views/proteins/` – page templates
- `public/excel/` – downloadable Excel / PDF files
- `docs/rebuild-log.md` – notes from the 2026 rebuild

## Running locally

```sh
bundle install
# point DATABASE_URL at a PostgreSQL database restored from a Heroku backup
export DATABASE_URL=postgres:///pcom_backup
bin/rails server
```

## Checks

```sh
bin/rails test           # automated tests
bin/brakeman             # static security analysis
bin/bundler-audit        # known vulnerabilities in gems
```

## Maintenance

- GitHub Actions runs the tests and security checks on every pull request, on every
  push to `master`, and on the 1st of every month.
- Dependabot opens a monthly pull request with gem / GitHub Actions updates.
  Review it (CI must be green) and merge – merging to `master` deploys to Heroku.
- `vendor/assets/javascripts/highcharts.js` is not covered by Dependabot; check for a
  new Highcharts release about once a year.

## Production settings (Heroku config vars)

- `DATABASE_URL` – set by Heroku Postgres
- `SECRET_KEY_BASE` – random secret used to sign cookies (never commit it)
