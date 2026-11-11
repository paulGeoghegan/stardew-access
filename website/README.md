# Stardew Access Documentation Site

This directory contains the Docusaurus-powered documentation site for Stardew Access.

## Getting Started

1. Install dependencies:
   ```
   npm install
   ```
2. Start the local dev server:
   ```
   npm run start
   ```
3. Build the static site:
   ```
   npm run build
   ```

## Structure

- `/docs`: Reference docs (setup, features, keybindings, config, commands) and `changelogs/`
- `/guides`: Gameplay guides, served at `/guides`
- `/i18n`: Localization files
- `compiler_script.rb`: Compiles `docs` and `guides` to html for the mod's offline docs (`ruby compiler_script.rb`)
- `docs/changelogs/scripts`: Python scripts used by the CI workflows to generate changelogs and release notes

## Deployment

The site is built and deployed to GitHub Pages by `.github/workflows/docs.yml` on pushes to `development`.
Pull requests that touch `website/` only run the build, so broken links are caught before merging.
