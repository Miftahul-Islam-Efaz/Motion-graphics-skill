#!/usr/bin/env bash
# Usage: scripts/analyze_ref.sh ref.mp4 [outdir] -> contact sheets, cuts, spectrogram, audio (first 15 s)
set -e; IN="$1"; O="${2:-cache/ref_$(basename "${IN%.*}")}"; mkdir -p "$O/f"
ffprobe -v error -show_entries format=duration:stream=width,height,r_frame_rate -of compact "$IN" | tee "$O/info.txt"
ffmpeg -v error -y -t 15 -i "$IN" -vf "fps=4,scale=270:-2" "$O/f/%03d.jpg"
args=(); for f in "$O"/f/*.jpg; do n=$((10#$(basename "$f" .jpg))); args+=(-label "$(awk "BEGIN{printf \"%.2fs\",($n-1)/4}")" "$f"); done
montage "${args[@]:0:60}" -tile 6x -geometry +3+3 "$O/sheet_a.jpg"
[ ${#args[@]} -gt 60 ] && montage "${args[@]:60}" -tile 6x -geometry +3+3 "$O/sheet_b.jpg"
ffmpeg -t 15 -i "$IN" -vf "select='gt(scene,0.3)',showinfo" -f null - 2>&1 | grep -o "pts_time:[0-9.]*" | cut -d: -f2 > "$O/cuts.txt" || true
ffmpeg -v error -y -t 15 -i "$IN" -lavfi "showspectrumpic=s=1500x400:legend=1:scale=log:fscale=log" "$O/spectrogram.png"
ffmpeg -v error -y -t 15 -i "$IN" -ac 1 -ar 16000 "$O/audio.wav"
echo "Done -> $O  (view sheets + spectrogram; transcribe audio.wav with faster-whisper word_timestamps=True)"
