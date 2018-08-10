class Xsane < Formula
  desc "Graphical scanning frontend"
  homepage "http://www.xsane.org"
  url "https://fossies.org/linux/misc/xsane-0.999.tar.gz"
  sha256 "5782d23e67dc961c81eef13a87b17eb0144cae3d1ffc5cf7e0322da751482b4b"
  revision 3

  bottle do
    rebuild 1
    sha256 "7f234a48d7f33e3e1bb22e6a4b2e6aec9db2ee7ba3e6dd085ee9706514885a75" => :high_sierra
    sha256 "5ada91ddf8fb46214734f8059f1dbdd0cdace37e9accd7ea93c525f77ed56a54" => :sierra
    sha256 "4423175a44373078992ca2a2fd39e012495459ff8293676e39320600fc24759e" => :el_capitan
  end

  depends_on "pkg-config" => :build
  depends_on "gtk+"
  depends_on "sane-backends"

  # Needed to compile against libpng 1.5, Project appears to be dead.
  patch :p0 do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/e1a592d/xsane/patch-src__xsane-save.c-libpng15-compat.diff"
    sha256 "404b963b30081bfc64020179be7b1a85668f6f16e608c741369e39114af46e27"
  end

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/xsane", "--version"
  end
end
