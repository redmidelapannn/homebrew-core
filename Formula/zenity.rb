class Zenity < Formula
  desc "GTK+ dialog boxes for the command-line"
  homepage "https://live.gnome.org/Zenity"
  url "https://download.gnome.org/sources/zenity/3.22/zenity-3.22.0.tar.xz"
  sha256 "1ecdfa1071d383b373b8135954b3ec38d402d671dcd528e69d144aff36a0e466"

  bottle do
    rebuild 1
    sha256 "b706c2261970689845b16f9a5d1baf216e68a38c276f4d7e3855e76d8aa71843" => :sierra
    sha256 "97be6150fa589974b4c05904c2e4dde8382e1a6d40077ca0f178e47a79ed91ed" => :el_capitan
    sha256 "4cca8369eeb0308a0eae243930be0502e9dc8a21d04bb5327635bd4e9e1cf84b" => :yosemite
  end

  depends_on "pkg-config" => :build
  depends_on "intltool" => :build
  depends_on "itstool" => :build
  depends_on "libxml2"
  depends_on "gtk+3"
  depends_on "gnome-doc-utils"
  depends_on "scrollkeeper"

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    system bin/"zenity", "--help"
  end
end
