class Patchage < Formula
  desc "Modular patch bay for audio and MIDI systems based on Jack and Alsa"
  homepage "https://drobilla.net/software/patchage"
  url "https://download.drobilla.net/patchage-1.0.0.tar.bz2"
  sha256 "6b21d74ef1b54fa62be8d6ba65ca8b61c7b6b5230cc85e093527081239bfeda9"

  bottle do
    sha256 "7759ee27a53493fd8bf903ae4ed7ecabdc5ca8e43a5c41c71aa57088faa92ed8" => :mojave
    sha256 "bd79a1261da74b536cb647f70e8d2ba4d678266c53b4b124817ca93d833ccdfa" => :high_sierra
    sha256 "3735ad21a367ad672808af0be34a4710a67984d2bb2547bfc78781ae8165f522" => :sierra
  end

  depends_on "pkg-config" => :build
  depends_on "boost"
  depends_on "ganv"
  depends_on "glib"
  depends_on "glibmm"
  depends_on "gtk-mac-integration"
  depends_on "gtkmm"
  depends_on "jack"

  patch do
    url "http://git.drobilla.net/cgit.cgi/patchage.git/patch/src?id=4067bd81444736ddd7047210e2afdaaf9eaeaf40"
    sha256 "47f723a8c95ce11c1c0d72691e63694265d4a147fcdbbc4c6289222bd2a56be6"
  end
  patch do
    url "http://git.drobilla.net/cgit.cgi/patchage.git/patch/src?id=28903bcceaa43393492f5426dcd2ab079eeed3bd"
    sha256 "f2afd3adfc1409afdf07786ed25968b0829c78c416da2c84352e48bda5a3aaf2"
  end

  def install
    ENV.cxx11

    system "./waf", "configure", "--prefix=#{prefix}"
    system "./waf", "build"
    system "./waf", "install"
  end

  test do
    system "#{bin}/patchage", "--help"
  end
end
