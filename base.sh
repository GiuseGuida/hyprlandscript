#!/usr/bin/env bash

# ──────────────────────────────────────────────────────────────
# 🧠 Hyprland Setup Script - Full Cyber Basic Pack by Giuseppe
# ──────────────────────────────────────────────────────────────

set -e

# ───── Funzioni ─────
echo_banner() {
  echo -e "\n\033[1;36m>>> $1 <<<\033[0m\n"
}

error_exit() {
  echo -e "\033[1;31m[!!] Errore: $1\033[0m" >&2
  exit 1
}

[ "$(id -u)" -ne 0 ] && error_exit "Lancialo come root o con sudo."

# ───── Aggiornamento ─────
echo_banner "Aggiorno il sistema..."
pacman -Syu --noconfirm

# ───── Base ─────
echo_banner "Installo i pacchetti base utili"
pacman -S --noconfirm git curl wget unzip neofetch btop htop zsh zsh-completions ripgrep fd exa starship \
  noto-fonts noto-fonts-emoji ttf-fira-code ttf-jetbrains-mono papirus-icon-theme \
  thunar thunar-volman thunar-archive-plugin file-roller gvfs

# ───── Hyprland + Wayland toolz ─────
echo_banner "Installo Hyprland e tools base Wayland"
pacman -S --noconfirm hyprland xdg-desktop-portal-hyprland waybar kitty rofi wofi dolphin dunst nwg-look xwayland \
  polkit-gnome brightnessctl wl-clipboard grim slurp swappy

# ───── Configura Waybar ─────
echo_banner "Fixo Waybar (modulo glitch e preset)"
mkdir -p /home/$SUDO_USER/.config/waybar
cat <<EOF > /home/$SUDO_USER/.config/waybar/config.jsonc
{
  "layer": "top",
  "position": "top",
  "modules-left": ["clock"],
  "modules-center": ["hyprland/workspaces"],
  "modules-right": ["network", "pulseaudio", "battery", "tray"],
  "clock": {
    "format": "%a %d %b %H:%M"
  }
}
EOF

cat <<EOF > /home/$SUDO_USER/.config/waybar/style.css
* {
  font-family: "JetBrainsMono Nerd Font", sans-serif;
  font-size: 13px;
  color: #f8f8f2;
  background: rgba(0,0,0,0);
  border: none;
}
EOF
chown -R $SUDO_USER:$SUDO_USER /home/$SUDO_USER/.config/waybar

# ───── Oh My Zsh ─────
echo_banner "Installo Oh My Zsh"
export RUNZSH=no
export CHSH=no
sudo -u $SUDO_USER sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# Plugin zsh
sudo -u $SUDO_USER git clone https://github.com/zsh-users/zsh-autosuggestions /home/$SUDO_USER/.oh-my-zsh/custom/plugins/zsh-autosuggestions
sudo -u $SUDO_USER git clone https://github.com/zsh-users/zsh-syntax-highlighting /home/$SUDO_USER/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting

cat <<EOF > /home/$SUDO_USER/.zshrc
export ZSH=\"\$HOME/.oh-my-zsh\"
ZSH_THEME=\"agnoster\"
plugins=(git zsh-autosuggestions zsh-syntax-highlighting)
source \$ZSH/oh-my-zsh.sh
eval \"\\$(starship init zsh)\"
neofetch
EOF
chown $SUDO_USER:$SUDO_USER /home/$SUDO_USER/.zshrc

# ───── Starship Prompt ─────
echo_banner "Configuro Starship"
mkdir -p /home/$SUDO_USER/.config
cat <<EOF > /home/$SUDO_USER/.config/starship.toml
add_newline = false

[character]
success_symbol = "[➜](bold green)"
error_symbol = "[✗](bold red)"
EOF
chown -R $SUDO_USER:$SUDO_USER /home/$SUDO_USER/.config/starship.toml

# ───── Dconf GNOME fix per polkit ─────
echo_banner "Abilito polkit agent"
mkdir -p /etc/xdg/autostart
cat <<EOF > /etc/xdg/autostart/polkit-gnome-agent.desktop
[Desktop Entry]
Type=Application
Name=PolicyKit Authentication Agent
Exec=/usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1
OnlyShowIn=Hyprland;
NoDisplay=false
X-GNOME-Autostart-enabled=true
EOF

# ───── Fine ─────
echo_banner "Completato! Riavvia e avvia Hyprland con zsh e tutto configurato"
chsh -s /bin/zsh $SUDO_USER

exit 0
