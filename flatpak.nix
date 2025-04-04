{ config, pkgs, lib, ... }:

let
  # We point directly to 'gnugrep' instead of 'grep'
  grep = pkgs.gnugrep;

  # 1. Declare the Flatpaks you *want* on your system
  desiredFlatpaks = [
    "org.mozilla.firefox"
    "org.libreoffice.LibreOffice"
    "io.github.flattool.Warehouse"
    "com.github.tchx84.Flatseal"
    "io.github.giantpinkrobots.flatsweep"
    "net.codelogistics.webapps"
    "com.jeffser.Alpaca"
    "info.febvre.Komikku"
    "org.gimp.GIMP"
    "com.calibre_ebook.calibre"
    "org.zotero.Zotero"
    "com.zettlr.Zettlr"
    "org.ferdium.Ferdium"
    "page.tesk.Refine"
    "org.localsend.localsend_app"
    "dev.qwery.AddWater"
    "net.lutris.Lutris"
    "dev.vencord.Vesktop"
    "com.heroicgameslauncher.hgl"
    "com.valvesoftware.Steam"
    "io.github.Foldex.AdwSteamGtk"
    "com.usebottles.bottles"
    "com.vysp3r.ProtonPlus"
    "re.sonny.Eloquent"
    "de.haeckerfelix.Fragments"
    "io.github.dvlv.boxbuddyrs"
    "org.freedesktop.Platform.VulkanLayer.MangoHud"
    "org.freedesktop.Platform.VulkanLayer.gamescope"
    "com.valvesoftware.Steam.CompatibilityTool.Proton-GE"
    "net.codelogistics.webapps"
    "org.gnome.gitlab.somas.Apostrophe"
    "io.gitlab.news_flash.NewsFlash"
    "io.gitlab.gregorni.Letterpress"
    "io.github.vikdevelop.SaveDesktop"
    "com.github.johnfactotum.Foliate"
    "io.github.ciromattia.kcc"
    "de.schmidhuberj.tubefeeder"
    "org.fedoraproject.MediaWriter"
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
