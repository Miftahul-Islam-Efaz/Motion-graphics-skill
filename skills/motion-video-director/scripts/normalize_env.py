#!/usr/bin/env python3
"""Normalise any user key file into <project>/.env without printing values.
Usage: python3 scripts/normalize_env.py <source.env> [<dest .env>]   (default dest: ./.env)
Maps loose names like 'pixabay-api', 'freesound client_secret' to standard env names."""
import re, sys, pathlib
MAP = [  # (regex on lowercased name, standard name) - first match wins
 (r'pixabay', 'PIXABAY_API_KEY'),
 (r'freesound.*(client.?id|\bid\b)', 'FREESOUND_CLIENT_ID'),
 (r'freesound', 'FREESOUND_API_KEY'),            # client secret / api key / token
 (r'pexels', 'PEXELS_API_KEY'),
 (r'unsplash.*secret', 'UNSPLASH_SECRET_KEY'),
 (r'unsplash', 'UNSPLASH_ACCESS_KEY'),
 (r'firecrawl', 'FIRECRAWL_API_KEY'),
 (r'eleven', 'ELEVENLABS_API_KEY'),
]
src = pathlib.Path(sys.argv[1]); dst = pathlib.Path(sys.argv[2] if len(sys.argv) > 2 else '.env')
cur = {}
if dst.exists():
    for l in dst.read_text(encoding='utf-8').splitlines():
        if '=' in l and not l.lstrip().startswith('#'):
            k, v = l.split('=', 1); cur[k.strip()] = v.strip()
for l in src.read_text(encoding='utf-8-sig').splitlines():
    if not l.strip() or l.lstrip().startswith('#'): continue
    m = re.match(r'\s*([^=:]+?)\s*[=:]\s*(.+)$', l)
    if not m: continue
    name, val = m.group(1).lower(), m.group(2).strip().strip('"\'')
    std = next((s for rx, s in MAP if re.search(rx, name)), re.sub(r'\W+', '_', m.group(1)).strip('_').upper())
    cur[std] = val
dst.write_text(''.join(f'{k}={v}\n' for k, v in cur.items()), encoding='utf-8')
gi = dst.parent / '.gitignore'
lines = gi.read_text(encoding='utf-8').splitlines() if gi.exists() else []
for pat in ('.env', '*.env'):
    if pat not in lines: lines.append(pat)
gi.write_text('\n'.join(lines) + '\n', encoding='utf-8')
for k in cur: print(f'✅ {k} set')
