class Monit < Formula
  desc "Manage and monitor processes, files, directories, and devices"
  homepage "https://mmonit.com/monit/"
  url "https://mmonit.com/monit/dist/monit-5.21.0.tar.gz"
  mirror "https://fossies.org/linux/privat/monit-5.21.0.tar.gz"
  sha256 "fbf76163ed4a180854d378af60fed0cdbc5a8772823957234efc182ead10c03c"

  bottle do
    rebuild 1
    sha256 "702a35685b3f1a31d4c5e2b7069b528c10ff2d3a9ce1143a68d737282d10e6d0" => :sierra
    sha256 "d4617d400b7fdb93725195c018d54788d3fa97fdf12d8410bfc61982984cc53d" => :el_capitan
    sha256 "6893dc93baf5750a8216bb319aa1602212e13ed184e6e9d89fe6c687a0750fed" => :yosemite
  end

  depends_on "openssl"

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--localstatedir=#{var}/monit",
                          "--sysconfdir=#{etc}/monit",
                          "--with-ssl-dir=#{Formula["openssl"].opt_prefix}"
    system "make", "install"
    pkgshare.install "monitrc"
  end

  test do
    system bin/"monit", "-c", pkgshare/"monitrc", "-t"
  end
end
