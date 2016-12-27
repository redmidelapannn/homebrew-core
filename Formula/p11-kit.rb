class P11Kit < Formula
  desc "Library to load and enumerate PKCS#11 modules"
  homepage "https://p11-glue.freedesktop.org"
  url "https://github.com/p11-glue/p11-kit/releases/download/0.23.3/p11-kit-0.23.3.tar.gz"
  sha256 "d487f04dba3f9e8256f53034c59c944ca45fd7b8434c095da6a74079644dcd82"

  bottle do
    rebuild 1
    sha256 "6d461fc8be88248c577cf85695b82d4a08a8c8c7fdd4e93cd8a2e36b724e730f" => :sierra
    sha256 "3356b8f02cdd976be79c5ec462c3163cf01b7e71bd3227a7a5cde35018577b1f" => :el_capitan
    sha256 "44cc6db223ac8494bfccab2c340e069a3e41cbfdc66391a046eacab92b05edd7" => :yosemite
  end

  head do
    url "https://github.com/p11-glue/p11-kit.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "gettext" => :build
    depends_on "libtool" => :build
  end

  depends_on "libffi"
  depends_on "pkg-config" => :build

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
