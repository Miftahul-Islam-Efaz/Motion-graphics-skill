<div align="center">

# Motion Video Director

**A Claude Code skill for motion graphics and video editing.**

Plan, animate, edit, voice and sound-design complete videos with Claude Code, Codex or Cursor. Everything renders locally, with no After Effects or Premiere.

<img src="assets/hero.gif" alt="Laptop reveal animation rendered entirely in code by Claude Code" width="760">

<sub>Every frame above was written and rendered by Claude Code using this skill.</sub>

</div>

## Overview

Motion Video Director turns a coding agent into a video production team. It handles the work a motion designer, editor and sound designer would normally do:

- Motion graphics and animated explainers, drawn in code (Canvas, SVG, Three.js, GSAP)
- Editing raw footage and talking-head clips: cuts, punch zooms, captions, B-roll, text behind the subject
- Voiceover scripts for ElevenLabs, with word-level timing for every shot
- Sound design synced to the frame and mixed to platform loudness (-14 LUFS)
- Final MP4 renders in 9:16, 16:9 or 1:1

The skill is a production playbook (`SKILL.md`) plus a set of helper scripts. The agent follows a fixed process with approval gates, so you review the script, the plan and a preview before anything is fully rendered.

## Examples

All of these were made with this skill.

| AI Creates Motion Graphic | Motion keyboard | Brud Code launch |
|:---:|:---:|:---:|
| [<img src="assets/reel-ai-creates-motion-graphic.jpg" width="240" alt="AI Creates Motion Graphic">](https://www.instagram.com/reel/DeImcItix7Z/) | [<img src="assets/reel-motion-keyboard.jpg" width="240" alt="Motion keyboard">](https://www.instagram.com/reel/DeH5WTZgSmX/) | [<img src="assets/reel-brud-code.jpg" width="240" alt="Brud Code launch">](https://www.instagram.com/reel/Dd54bw2J5bc/) |
| [Watch on Instagram](https://www.instagram.com/reel/DeImcItix7Z/) | [Watch on Instagram](https://www.instagram.com/reel/DeH5WTZgSmX/) | [Watch on Instagram](https://www.instagram.com/reel/Dd54bw2J5bc/) |

The launch ad for this skill was also produced with it: a 56-second, 1080p SaaS ad with voiceover, 2D/3D animation and a full sound mix.

<div align="center">
<img src="assets/clawd-ending.gif" alt="Closing sequence of the launch ad" width="640">
</div>

## Installation

### Claude Code plugin

```text
/plugin marketplace add Miftahul-Islam-Efaz/Motion-graphics-skill
/plugin install motion-video-director@motion-graphics-skill
```

### Claude Code skill (manual)

```bash
git clone https://github.com/Miftahul-Islam-Efaz/Motion-graphics-skill.git

# available in every project
cp -r Motion-graphics-skill/skills/motion-video-director ~/.claude/skills/

# or only in the current project
cp -r Motion-graphics-skill/skills/motion-video-director .claude/skills/
```

### Codex, Cursor and other agents

Copy `skills/motion-video-director/` into your project, then tell the agent:

```text
Read skills/motion-video-director/SKILL.md and follow it for this video project.
```

Any agent with terminal and file access can use it.

## Usage

Describe the video you want and attach references if you have them.

```text
Make a 30-second 9:16 launch reel for my SaaS. References attached.
```

```text
Edit my raw talking-head clip into a reel with captions, punch zooms and B-roll.
```

```text
Create a 45-second product explainer of our dashboard. Clean UI animation, subtle sound design.
```

The agent then works through these steps:

1. **Brief.** Collects references, story, audience, format and length.
2. **Voiceover script.** Writes a script ready to paste into ElevenLabs. You generate the MP3 and send it back.
3. **Storyboard.** Times every shot to the words in the voiceover.
4. **Build.** Animates the scenes in code and edits any footage you provided.
5. **Preview.** Renders contact sheets of each scene and fixes problems before the full render.
6. **Render and mix.** Exports the final video with sound design and loudness normalization, then runs a QA checklist.

You approve the script, the plan and the preview before the final render. Progress is logged in `PROGRESS.md`, so a new session can continue where the last one stopped.

## What the skill covers

| Area | Details |
|---|---|
| Directing | Hooks in the first 3 seconds, pacing, shot types, J/L cuts, match cuts, CTA structure |
| Editing intensity | Five levels, from fast-paced reels to restrained corporate video |
| Motion graphics | Kinetic typography, 3D text, UI mockups, cursor animation, stickers, particles, Lottie |
| Footage editing | Punch zooms, subject cutouts (RVM, SAM2), captions behind the subject, speed ramps |
| 3D | Three.js product shots, floating cards, camera fly-throughs, extruded logos |
| Animation | The 12 principles of animation, easing, staggering, overshoot |
| Color and layout | 60-30-10 color, WCAG contrast, safe zones for 9:16 platforms |
| Sound | Risers, impacts and whooshes synced to the frame, ducking under voice, -14 LUFS / -1.5 dBTP |
| Voiceover | ElevenLabs scripting, audio QA, word timestamps with faster-whisper |
| Assets | Fonts, sound effects and stock footage via Firecrawl, Freesound, Pexels, Pixabay and LottieFiles. The agent can also browse sites like Pinterest and Behance with Playwright |

## Repository structure

```text
.claude-plugin/
  plugin.json            Plugin manifest
  marketplace.json       Marketplace entry for one-command install
skills/motion-video-director/
  SKILL.md               The production playbook
  scripts/
    preflight.sh         Checks Node, ffmpeg, Playwright, Python tools and API keys
    preview.mjs          Renders a time range to a contact sheet for quick review
    analyze_ref.sh       Breaks a reference video into frames, cuts and audio
    create_env.sh        Creates a .env file with empty API key slots
    normalize_env.py     Converts an existing key file into a clean .env
```

## Requirements

Required: Node.js 18+, ffmpeg and ffprobe, and Playwright with headless Chrome.

Optional: Python 3.10+ with `faster-whisper`, `rembg` and `demucs` for transcription, cutouts and stem separation. You can also add API keys or MCP servers for ElevenLabs, Firecrawl, Freesound, Pexels, Pixabay and LottieFiles.

To see what is installed and what is missing, run:

```bash
bash skills/motion-video-director/scripts/preflight.sh
```

API keys are stored in a local `.env` file, which is excluded from git.

## FAQ

**Do I need After Effects or Premiere Pro?**
No. Animation is written in code and rendered with headless Chrome and ffmpeg.

**Can it edit existing footage, or only create animation?**
Both. It can cut, caption, grade and sound-design raw clips, and combine them with motion graphics.

**What does it cost to run?**
Rendering is free and local. ElevenLabs and some stock-media APIs have their own pricing; their free tiers cover most projects.

**Does it work outside Claude Code?**
Yes. It works with any agent that can run terminal commands and edit files, including Codex and Cursor.

## Author

Made by [Miftahul Islam Efaz](https://www.instagram.com/miftahul_islam_efaz/). If you make something with it, tag me on Instagram.

© 2026 Miftahul Islam Efaz. All rights reserved.
