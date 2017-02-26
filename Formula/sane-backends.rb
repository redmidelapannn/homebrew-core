class SaneBackends < Formula
  desc "Backends for scanner access"
  homepage "http://www.sane-project.org/"
  revision 1

  head "https://anonscm.debian.org/cgit/sane/sane-backends.git"

  stable do
    url "https://fossies.org/linux/misc/sane-backends-1.0.25.tar.gz"
    mirror "https://mirrors.kernel.org/debian/pool/main/s/sane-backends/sane-backends_1.0.25.orig.tar.gz"
    sha256 "a4d7ba8d62b2dea702ce76be85699940992daf3f44823ddc128812da33dc6e2c"

    # Fixes some missing headers missing error. Reported upstream
    # https://lists.alioth.debian.org/pipermail/sane-devel/2015-October/033972.html
    patch do
      url "https://raw.githubusercontent.com/Homebrew/formula-patches/6dd7790c/sane-backends/1.0.25-missing-types.patch"
      sha256 "f1cda7914e95df80b7c2c5f796e5db43896f90a0a9679fbc6c1460af66bdbb93"
    end
  end

  bottle do
    rebuild 1
    sha256 "dc4f0ce5430cc4d820793cb6a179b69b5070394e623f673b3e6033491b986fa2" => :sierra
    sha256 "b8e6e84681cea4b77b2a2ca958482860dc666b7a19e37a0db0a453f9d620d8b9" => :el_capitan
    sha256 "f20a99dcdc29516a2ddaae42de91d14d51847217114a5ce924e52d19f4add950" => :yosemite
  end

  depends_on "jpeg"
  depends_on "libtiff"
  depends_on "libusb-compat"
  depends_on "openssl"
  depends_on "net-snmp"

  def install
    ENV.deparallelize # Makefile does not seem to be parallel-safe
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--localstatedir=#{var}",
                          "--without-gphoto2",
                          "--enable-local-backends",
                          "--enable-libusb",
                          "--disable-latex"
    system "make"
    system "make", "install"
  end

  def post_install
    # Some drivers require a lockfile
    (var/"lock/sane").mkpath
  end

  test do
    assert_match prefix.to_s, shell_output("#{bin}/sane-config --prefix")
  end
end
