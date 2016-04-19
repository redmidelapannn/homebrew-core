class Zenity < Formula
  desc "GTK+ dialog boxes for the command-line"
  homepage "https://live.gnome.org/Zenity"
  url "https://download.gnome.org/sources/zenity/3.20/zenity-3.20.0.tar.xz"
  sha256 "02e8759397f813c0a620b93ebeacdab9956191c9dc0d0fcba1815c5ea3f15a48"

  bottle do
    sha256 "6b3cf5bdd6dbbaa73003229b24af7aa4aaabfe1c5762bbefd654f20346bfc5a8" => :mavericks
  end

  depends_on "pkg-config" => :build
  depends_on "intltool" => :build
  depends_on "itstool" => :build
  depends_on "libxml2"
  depends_on "gtk+3"
  depends_on "gnome-doc-utils"
  depends_on "scrollkeeper"
  depends_on "webkitgtk" => :recommended


  def install
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    system "#{bin}/zenity", "--help"
  end
end
