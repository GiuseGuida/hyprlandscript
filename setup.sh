#!/bin/bash
set -e

echo "[+] Aggiornamento sistema e installazione base-devel"
sudo pacman -Syu --noconfirm
sudo pacman -S --noconfirm base-devel git curl wget zsh unzip

echo "[+] Installazione Hyprland-related tools"
sudo pacman -S --noconfirm hyprpaper hyprpicker waybar rofi wofi dunst kitty thunar thunar-archive-plugin pavucontrol pipewire wireplumber

echo "[+] Installazione tools da pentesting (light Kali mode)"
sudo pacman -S --noconfirm nmap wireshark-qt aircrack-ng john metasploit sqlmap nikto netcat htop btop neofetch

echo "[+] Installazione extra tools utili"
sudo pacman -S --noconfirm starship bat exa lf zoxide fzf ripgrep thefuck

echo "[+] Setup ZSH e Starship"
chsh -s $(which zsh)
echo 'eval "$(starship init zsh)"' >> ~/.zshrc
echo 'eval "$(zoxide init zsh)"' >> ~/.zshrc
echo 'eval "$(thefuck --alias)"' >> ~/.zshrc

echo "[+] Clonazione config Hyprland personalizzata"
git clone https://github.com/hyprwm/hyprland /tmp/hyprland-config
mkdir -p ~/.config/hypr
cp -r /tmp/hyprland-config/example/hyprland/* ~/.config/hypr/

echo "[+] Temi cyberpunk & nerd fonts"
sudo pacman -S --noconfirm ttf-jetbrains-mono-nerd ttf-firacode-nerd ttf-font-awesome
mkdir -p ~/.themes ~/.icons
git clone https://github.com/dracula/gtk.git ~/.themes/Dracula
git clone https://github.com/catppuccin/gtk.git ~/.themes/Catppuccin

echo "[+] Suoni cyberpunk opzionali"
read -p "Vuoi installare suoni cyberpunk per notifiche e boot? (y/n): " cyber
if [[ "$cyber" == "y" ]]; then
  mkdir -p ~/.local/share/sounds
  wget -q https://github.com/Saiyan1989/hack-sounds/raw/main/startup.ogg -O ~/.local/share/sounds/startup.ogg
  canberra-gtk-play --file=~/.local/share/sounds/startup.ogg
fi

echo "[+] Permessi Wireshark"
sudo gpasswd -a $USER wireshark

echo "[+] Installazione completata con successo!"
echo "➡️ Riavvia o fai logout per usare Hyprland a pieno!"
