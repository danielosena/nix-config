{ config, pkgs, lib, ... }:

let
  # We point directly to 'gnugrep' instead of 'grep'
  grep = pkgs.gnugrep;

  # 1. Declare the Flatpaks you *want* on your system
  desiredFlatpaks = [
    "org.mozilla.firefox"
    "org.dupot.easyflatpak"
    "org.libreoffice.LibreOffice"
    "io.github.flattool.Warehouse"
    "com.github.tchx84.Flatseal"
    "io.github.giantpinkrobots.flatsweep"
    "it.mijorus.gearlever"
    "net.codelogistics.webapps"
    "com.jeffser.Alpaca"
    "info.febvre.Komikku"
    "org.gimp.GIMP"
    "com.calibre_ebook.calibre"
    "org.zotero.Zotero"
    "com.zettlr.Zettlr"
    "org.ferdium.Ferdium"
    "net.davidotek.pupgui2"
    "org.freedesktop.Platform.VulkanLayer.MangoHud"
    "page.tesk.Refine"
    "org.localsend.localsend_app"
    "dev.qwery.AddWater"
    "net.lutris.Lutris"
    "io.github.vikdevelop.SaveDesktop"
    "dev.vencord.Vesktop"
    "com.heroicgameslauncher.hgl"
    "com.valvesoftware.Steam"
    "io.github.Foldex.AdwSteamGtk"
    "org.freedesktop.Platform.VulkanLayer.gamescope"
    "net.davidotek.pupgui2"
    "com.usebottles.bottles"
    "ru.linux_gaming.PortProton"
    "com.vysp3r.ProtonPlus"
  ];
in
{
 system.activationScripts.flatpakManagement = {
   text = ''
     # 1. Ensure the Flathub repo is added
     ${pkgs.flatpak}/bin/flatpak remote-add --if-not-exists flathub \
       https://flathub.org/repo/flathub.flatpakrepo

     # 2. Get currently installed Flatpaks
     installedFlatpaks=$(${pkgs.flatpak}/bin/flatpak list --app --columns=application)

     # 3. Remove any Flatpaks that are NOT in the desired list
     for installed in $installedFlatpaks; do
       if ! echo "${toString desiredFlatpaks}" | ${pkgs.gnugrep}/bin/grep -q "$installed"; then
         echo "Removing $installed because it's not in the desiredFlatpaks list."
         ${pkgs.flatpak}/bin/flatpak uninstall -y --noninteractive "$installed"
       fi
     done

     # 4. Install or re-install the Flatpaks you DO want
     for app in ${lib.concatStringsSep " " desiredFlatpaks}; do
       echo "Ensuring $app is installed."
       ${pkgs.flatpak}/bin/flatpak install -y --noninteractive flathub "$app"
     done

     # 5. Update all installed Flatpaks
     ${pkgs.flatpak}/bin/flatpak update -y
   '';
 };
}
