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
    sha256 "19b3598a44c3ecd44d927e4337245b9a741095b8208cac53d921d70f6814e908" => :sierra
    sha256 "e249feeb62272be2d42a3d207b0197df6ae460f93c4b7dacbedf25bd59d6c029" => :el_capitan
    sha256 "c0a6896ae757033f032a4213b1aa0587c721aa15f4e570cf875698b58c3ae23b" => :yosemite
  end

  option :universal

  depends_on "jpeg"
  depends_on "libtiff"
  depends_on "libusb-compat"
  depends_on "openssl"
  depends_on "net-snmp"

  def install
    ENV.universal_binary if build.universal?
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
