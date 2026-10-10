#!/usr/bin/env bash
# Creates <project>/.env with empty key slots for the user to fill in. Never overwrites existing values.
# Usage: bash scripts/create_env.sh [project_dir]
cd "${1:-.}" || exit 1
touch .env
add(){ grep -qE "^$1=" .env || printf '%s=\n' "$1" >> .env; }
if ! grep -q "motion-video-director" .env; then
  { printf '# API keys for motion-video-director. Paste each key right after "=" (no spaces, no quotes), then SAVE.\n# Leave a line empty if you do not use that platform. Never share this file.\n'; cat .env; } > .env.tmp && mv .env.tmp .env
fi
for k in PIXABAY_API_KEY FREESOUND_CLIENT_ID FREESOUND_API_KEY UNSPLASH_APPLICATION_ID UNSPLASH_ACCESS_KEY UNSPLASH_SECRET_KEY FIRECRAWL_API_KEY; do add "$k"; done
for p in .env '*.env' node_modules/ cache/ models/; do grep -qxF "$p" .gitignore 2>/dev/null || echo "$p" >> .gitignore; done
echo "Created/updated: $(pwd)/.env"
for k in $(grep -oE '^[A-Z_]+=' .env | tr -d '='); do grep -qE "^$k=.+" .env && echo "✅ $k filled" || echo "⬜ $k empty"; done
