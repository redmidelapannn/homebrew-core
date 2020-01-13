class P11Kit < Formula
  desc "Library to load and enumerate PKCS#11 modules"
  homepage "https://p11-glue.freedesktop.org"
  url "https://github.com/p11-glue/p11-kit/releases/download/0.23.18.1/p11-kit-0.23.18.1.tar.gz"
  sha256 "34c3bd8c0050dd7c4e6228aecf0f168de0a1b34562ddbf74a1c70904c2523c6f"
  revision 1

  bottle do
    sha256 "de3057a063498fa754b4b450b7c0f4ad6aade84528a7979a817cc38f9c44692c" => :catalina
    sha256 "45de702832e4508134f0e211bffbecda8263c17257223c6e562fd91ba78558f5" => :mojave
    sha256 "22e0b08d47ef175033c61c55e6e2893803752bf8919517b4043e1e4ef7e3a7cf" => :high_sierra
  end

  head do
    url "https://github.com/p11-glue/p11-kit.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "gettext" => :build
    depends_on "libtool" => :build
  end

  depends_on "pkg-config" => :build
  depends_on "libffi"

  def install
    # https://bugs.freedesktop.org/show_bug.cgi?id=91602#c1
    ENV["FAKED_MODE"] = "1"

    if build.head?
      ENV["NOCONFIGURE"] = "1"
      system "./autogen.sh"
    end

    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--disable-trust-module",
                          "--prefix=#{prefix}",
                          "--sysconfdir=#{etc}",
                          "--with-module-config=#{etc}/pkcs11/modules",
                          "--without-libtasn1"
    system "make"
    system "make", "check"
    system "make", "install"
  end

  test do
    system "#{bin}/p11-kit", "list-modules"
  end
end
