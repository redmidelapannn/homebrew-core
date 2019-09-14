class Xsane < Formula
  desc "Graphical scanning frontend"
  homepage "https://wiki.ubuntuusers.de/XSane/"
  url "https://ftp.osuosl.org/pub/blfs/conglomeration/xsane/xsane-0.999.tar.gz"
  mirror "https://fossies.org/linux/misc/xsane-0.999.tar.gz"
  sha256 "5782d23e67dc961c81eef13a87b17eb0144cae3d1ffc5cf7e0322da751482b4b"
  revision 4

  bottle do
    rebuild 1
    sha256 "54599524ee09f3e7dfe44d131680a3fdc84f1c4e5b4a9498846c7dac44593b5e" => :mojave
    sha256 "19c8670d6e78625e0f451a367d238127f78358fb8f3b7ff9c7596fdd12289c34" => :high_sierra
    sha256 "ca5bd0ecb179976fc9062f6a8019fd55c660306f717c8b245e82977278cbfe50" => :sierra
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
