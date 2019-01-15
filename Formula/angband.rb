class Angband < Formula
  desc "Dungeon exploration game"
  homepage "https://rephial.org/"
  url "https://rephial.org/downloads/4.1/angband-4.1.3.tar.gz"
  sha256 "9402c4f8da691edbd4567a948c5663e1066bee3fcb4a62fbcf86b5454918406f"
  head "https://github.com/angband/angband.git"

  bottle do
    rebuild 1
    sha256 "de3df9944b2ed2083ce533c7963d35024bdb51e7a4486b2fc1518bc5352cc837" => :mojave
    sha256 "97140a603601b72738524631497a14fc6feb8dc665724a31e68dc47f0b6e31f7" => :high_sierra
    sha256 "689cff2e0e017df074ab321a60391dee9283ed534210075eec4e38d679024770" => :sierra
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build

  def install
    ENV["NCURSES_CONFIG"] = "#{MacOS.sdk_path}/usr/bin/ncurses5.4-config"
    system "./autogen.sh"
    system "./configure", "--prefix=#{prefix}",
                          "--bindir=#{bin}",
                          "--libdir=#{libexec}",
                          "--enable-curses",
                          "--disable-ncursestest",
                          "--disable-sdltest",
                          "--disable-x11",
                          "--with-ncurses-prefix=#{MacOS.sdk_path}/usr"
    system "make"
    system "make", "install"
  end

  test do
    system bin/"angband", "--help"
  end
end
