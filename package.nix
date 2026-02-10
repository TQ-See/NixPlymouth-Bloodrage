{ stdenvNoCC, pkgs ? import <nixpkgs> { }
, theme ? "Bloodrage"
, # TODO: Should be a list when more themes come
  bgColor ? "0, 0, 0"
, # rgb value between 0-1. TODO: Write hex to plymouth magic
}:

stdenvNoCC.mkDerivation {
  pname = "Bloodrage";
  version = "0.1.0";
  src = ./src;
  
  buildInputs = [
    pkgs.git
  ];
  
  unpackPhase = ''
  '';

  buildPhase = ''
    # Create theme
    cp template.plymouth "${theme}/${theme}.plymouth"
    sed -i 's/THEME/${theme}/g' "${theme}/${theme}.plymouth"
    sed -i 's/generic/${theme}/g' "${theme}/${theme}.plymouth"
    # Set the Background Color
    cp generic.script ${theme}
    sed -i 's/\(Window\.SetBackground[^ ]*\).*/\1 (${bgColor});/' ${theme}/generic.script
  '';

  installPhase = ''
    # Set the Background Color
    cp generic.script ${theme}
    sed -i 's/\(Window\.SetBackground[^ ]*\).*/\1 (${bgColor});/' ${theme}/generic.script

    # Copy files
    install -m 755 -vDt "$out/share/plymouth/themes/${theme}" "${theme}/${theme}."{plymouth,script}
    install -m 644 -vDt "$out/share/plymouth/themes/${theme}" "${theme}/"*png
    # Fix path
    sed -i "s@\/usr\/@$out\/@" "$out/share/plymouth/themes/${theme}/${theme}.plymouth"
  '';
}
