#!/usr/bin/env bash

# ─── Funzioni base ───────────────────────────────────────────────
echo_banner() {
  echo -e "\n\033[1;35m### $1 ###\033[0m\n"
}

error_exit() {
  echo -e "\033[1;31mErrore: $1\033[0m" >&2
  exit 1
}

# ─── Controlli ───────────────────────────────────────────────────
[ "$(id -u)" -ne 0 ] && error_exit "Lancia lo script come root o con sudo."

# ─── Aggiorna sistema ────────────────────────────────────────────
echo_banner "Aggiornamento sistema"
pacman -Syu --noconfirm || error_exit "Errore aggiornamento pacchetti"

# ─── Installa pacchetti base ─────────────────────────────────────
echo_banner "Installazione pacchetti base"
pacman -S --noconfirm git curl wget unzip zsh zsh-completions neofetch btop htop ripgrep fd exa starship noto-fonts-emoji noto-fonts ttf-fira-code ttf-jetbrains-mono

# ─── Hyprland ────────────────────────────────────────────────────
echo_banner "Installazione Hyprland"
pacman -S --noconfirm hyprland xdg-desktop-portal-hyprland waybar kitty rofi thunar

# ─── Oh My Zsh ───────────────────────────────────────────────────
echo_banner "Installazione Oh My Zsh"
export RUNZSH=no
export CHSH=no
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" || error_exit "Errore installazione Oh My Zsh"

# Plugin ZSH
echo_banner "Installazione plugin ZSH"
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting

# Configura ZSH
echo_banner "Configurazione .zshrc"
cat <<EOF > ~/.zshrc
export ZSH="\$HOME/.oh-my-zsh"
ZSH_THEME="agnoster"
plugins=(git zsh-autosuggestions zsh-syntax-highlighting)
source \$ZSH/oh-my-zsh.sh
eval "\$(starship init zsh)"
neofetch
EOF

# ─── Starship Prompt ─────────────────────────────────────────────
echo_banner "Configurazione Starship Prompt"
mkdir -p ~/.config
cat <<EOF > ~/.config/starship.toml
add_newline = false

[character]
success_symbol = "[➜](bold green)"
error_symbol = "[✗](bold red)"

[directory]
style = "cyan"
EOF

# ─── Toolz da guerra ─────────────────────────────────────────────
echo_banner "Installazione pentest tools"
pacman -S --noconfirm nmap wireshark-gtk metasploit hashcat john aircrack-ng burpsuite gobuster sqlmap hydra

# ─── Temi & Cyberpunk ────────────────────────────────────────────
echo_banner "Scarico temi cyberpunk"
mkdir -p ~/.themes ~/.icons
git clone https://github.com/EliverLara/candy-icons.git ~/.icons/Candy
git clone https://github.com/dracula/gtk.git ~/.themes/Dracula

# ─── Audio FX (opzionale) ────────────────────────────────────────
echo_banner "Cyberpunk sound FX (opzionale)"
read -p "Vuoi suoni cyberpunk all'avvio? [y/N]: " answer
if [[ "$answer" =~ ^[Yy]$ ]]; then
  mkdir -p ~/.config/autostart
  echo 'paplay /usr/share/sounds/freedesktop/stereo/message.oga' >> ~/.bash_profile
fi

# ─── Fine ─────────────────────────────────────────────────────────
echo_banner "Installazione completata. Riavvia per iniziare con Hyprland!"
chsh -s /bin/zsh $SUDO_USER

exit 0
