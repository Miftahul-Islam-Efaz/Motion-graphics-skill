#!/usr/bin/env bash
# Preflight for motion-video-director. Prints a status table; installs nothing.
ok(){ printf "✅ %-28s %s\n" "$1" "$2"; }; no(){ printf "❌ %-28s %s\n" "$1" "$2"; }
chk(){ local n="$1"; shift; if out=$("$@" 2>/dev/null | head -1); then ok "$n" "$out"; else no "$n" "missing"; fi; }
chk "node" node -v
chk "npm" npm -v
chk "python3" python3 --version
chk "ffmpeg" ffmpeg -version
chk "ffprobe" ffprobe -version
chk "playwright" npx --no-install playwright --version
for p in three gsap p5 p5.brush @motion-canvas/core @revideo/core; do
  if [ -d "node_modules/$p" ]; then ok "npm:$p" "installed"; else no "npm:$p" "not installed"; fi
done
for m in faster_whisper whisperx rembg torch onnxruntime demucs; do
  if python3 -c "import $m" 2>/dev/null; then ok "py:$m" "installed"; else no "py:$m" "not installed"; fi
done
ls models 2>/dev/null | grep -qi rvm && ok "model:RVM" "models/" || no "model:RVM" "not in models/"
ls models 2>/dev/null | grep -qi sam2 && ok "model:SAM2" "models/" || no "model:SAM2" "not in models/ (optional)"
[ -f .env ] && ok ".env" "present" || no ".env" "missing (API keys, see SKILL §0c)"
grep -qsE '(^|/)\*?\.env$|^\.env' .gitignore && ok ".gitignore .env" "ignored" || no ".gitignore .env" "add .env to .gitignore"
# key names only, values are never printed
for k in PIXABAY_API_KEY FREESOUND_API_KEY FREESOUND_CLIENT_ID PEXELS_API_KEY UNSPLASH_ACCESS_KEY FIRECRAWL_API_KEY ELEVENLABS_API_KEY; do
  grep -qE "^$k=.+" .env 2>/dev/null && ok "key:$k" "set" || no "key:$k" "not set (optional unless needed)"
done
other=$(find . -maxdepth 3 -name "*.env" ! -path "./.env" ! -path "./node_modules/*" 2>/dev/null | head -5)
[ -n "$other" ] && echo "ℹ️  other key files found (normalise into .env, SKILL §0c): $other"
for c in claude codex uvx; do command -v $c >/dev/null 2>&1 && ok "cli:$c" "available" || no "cli:$c" "not found (only needed for that agent / uvx MCPs)"; done
echo "MCPs (Playwright, Firecrawl, ElevenLabs, LottieFiles, Freesound, Pexels/Pixabay): verify via your agent's MCP tool list (e.g. 'claude mcp list', '/mcp'). Missing → SKILL §0b; no MCP → REST APIs in §0c."
