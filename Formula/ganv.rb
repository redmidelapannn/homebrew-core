class Ganv < Formula
  desc "Gtk widget for interactive graph-like environments"
  homepage "https://drobilla.net/software/ganv"
  url "https://download.drobilla.net/ganv-1.4.2.tar.bz2"

  bottle do
    cellar :any
    sha256 "65cd4f1d3d9a6d6412f77b0a3ed3169c8fad61044c76356f4c7599fdabb65606" => :mojave
    sha256 "228e440a74f26e06499dd1e063d0afcf904d506843b837d14d92a14f980d8ead" => :high_sierra
    sha256 "067ab2c1a423ae0b6d653fab34b5558a4141fbd7bdcd5846e8b52c0c5d400503" => :sierra
  end

  depends_on "pkg-config" => [:build, :test]
  depends_on "glib"
  depends_on "glibmm"
  depends_on "gobject-introspection"
  depends_on "graphviz"
  depends_on "gtk-mac-integration"
  depends_on "gtkmm"

  def install
    ENV.cxx11

    system "./waf", "configure", "--prefix=#{prefix}"
    system "./waf", "build"
    system "./waf", "install"
  end

  test do
    system "pkg-config", "ganv-1", "--libs", "--cflags"
  end
end
