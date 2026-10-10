#!/usr/bin/env bash
# Installs Monitor Arranger for the current user:
#   ~/.local/bin/monitor-arranger
#   ~/.local/share/applications/monitor-arranger.desktop
set -euo pipefail

src="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
bin_dir="$HOME/.local/bin"
app_dir="$HOME/.local/share/applications"

missing=()
python3 -c 'import gi; gi.require_version("Gtk", "4.0"); gi.require_version("Adw", "1")' 2>/dev/null \
  || missing+=(python-gobject gtk4 libadwaita)
if ((${#missing[@]})); then
  echo "Missing dependencies: ${missing[*]}"
  echo "Install them with: omarchy pkg add ${missing[*]}"
  exit 1
fi
[[ -e /usr/lib/libgtk4-layer-shell.so ]] \
  || echo "Optional: install gtk4-layer-shell to enable the 'Identify' button."

install -Dm755 "$src/monitor-arranger" "$bin_dir/monitor-arranger"
# Absolute Exec path: ~/.local/bin is not always on the launcher's PATH.
sed "s|^Exec=.*|Exec=$bin_dir/monitor-arranger|" "$src/monitor-arranger.desktop" \
  | install -Dm644 /dev/stdin "$app_dir/monitor-arranger.desktop"

echo "Installed. Launch it from the app launcher or run: monitor-arranger"
