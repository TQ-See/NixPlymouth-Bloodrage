{ stdenvNoCC
, theme ? "Bloodrage"
, bgColor ? "0, 0, 0"
}:

stdenvNoCC.mkDerivation {
  pname = "${theme}-plymouth";
  version = "0.1.0";
  
  src = ./src;

  # Kita tidak butuh git di buildInputs jika hanya copy file
  buildInputs = [ ];

  # buildPhase digunakan untuk memanipulasi warna background pada script
  buildPhase = ''
    # Sesuaikan warna background di file .script yang ada di dalam folder tema
    # Mencari fungsi Window.SetBackground dan mengganti nilainya
    sed -i "s/\(Window\.SetBackgroundTopColor\s*\)([^)]*)/\1 (${bgColor})/" "${theme}/${theme}.script"
    sed -i "s/\(Window\.SetBackgroundBottomColor\s*\)([^)]*)/\1 (${bgColor})/" "${theme}/${theme}.script"
  '';

  installPhase = ''
    mkdir -p $out/share/plymouth/themes/${theme}
    
    # Copy semua isi dari folder tema (png, plymouth, script)
    cp -r ${theme}/* $out/share/plymouth/themes/${theme}/

    # Perbaiki path di file .plymouth agar menunjuk ke Nix Store, bukan /usr
    sed -i "s|/usr/share/plymouth/themes|$out/share/plymouth/themes|g" "$out/share/plymouth/themes/${theme}/${theme}.plymouth"
  '';
}
