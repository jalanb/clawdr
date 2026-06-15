---
allowed-tools: Bash(yt-dlp:*), Bash(python3:*), Bash(rm:*), Bash(mkdir:*), Read, Write
description: Transcribe a YouTube video to markdown using yt-dlp auto-captions
---

# MyTube - YouTube Transcription

Transcribe a YouTube video to a markdown file using yt-dlp's auto-captions.

## Arguments

$ARGUMENTS should contain a YouTube URL. If not provided, ask the user.

## Your Task

### 1. Get video metadata

```bash
yt-dlp -j --skip-download "$URL" 2>/dev/null
```

Extract: `title`, `channel`, `duration_string`, `webpage_url`

### 2. Ask about filename

Default: sanitized video title (replace `/` `:` `"` with `-`, trim to 80 chars)

Ask user: "Save as `<default>.md` or provide a different name?"

### 3. Download auto-captions

```bash
yt-dlp --write-auto-sub --sub-lang "en-orig,en" --sub-format vtt --skip-download -o "/tmp/mytube_$$" "$URL"
```

The VTT file will be at `/tmp/mytube_$$.en-orig.vtt` or `/tmp/mytube_$$.en.vtt`

### 4. Clean VTT to plain text

The VTT format has timestamps, position markers, and duplicate lines. Clean with:

```python
import re
import sys

text = sys.stdin.read()
# Remove WEBVTT header and metadata
text = re.sub(r'^WEBVTT\n.*?\n\n', '', text, flags=re.DOTALL)
# Remove timestamps and position markers
text = re.sub(r'\d{2}:\d{2}:\d{2}\.\d{3} --> .*\n', '', text)
# Remove inline timestamps like <00:00:00.400>
text = re.sub(r'<[\d:.]+>', '', text)
# Remove formatting tags like <c>
text = re.sub(r'</?c>', '', text)
# Decode HTML entities
text = text.replace('&gt;', '>').replace('&lt;', '<').replace('&amp;', '&')
# Remove duplicate lines (VTT shows progressive reveal)
lines = []
for line in text.split('\n'):
    line = line.strip()
    if line and (not lines or line != lines[-1]):
        lines.append(line)
# Join into paragraphs (blank line every ~5 sentences for readability)
print('\n'.join(lines))
```

### 5. Output directory

Write all transcripts to /opt/clones/github/jalanb/clawdrs/clawdr/commands/mytube/transcripts

### 6. Write markdown file

Create `transcripts/<filename>.md` with:

```markdown
# <Title>

**Channel**: <channel>
**Duration**: <duration_string>
**URL**: <webpage_url>
**Transcribed**: <today's date YYYY-MM-DD>

---

<cleaned transcript text>
```

### 7. Cleanup

```bash
rm -f /tmp/mytube_$$.*
```

### 8. Report

Tell the user: "Saved to `/opt/clones/github/jalanb/clawdrs/clawdr/commands/mytube/transcripts/<filename>.md`"
