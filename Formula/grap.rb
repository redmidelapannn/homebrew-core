class Grap < Formula
  desc "Language for typesetting graphs"
  homepage "http://www.lunabase.org/~faber/Vault/software/grap/"
  # SSL issues with the canonical URL http://www.lunabase.org/~faber/Vault/software/grap/grap-1.45.tar.gz
  # Contacted faber AT lunabase DOT org 19 Sep 2017
  url "https://mirrors.ocf.berkeley.edu/debian/pool/main/g/grap/grap_1.45.orig.tar.gz"
  mirror "https://mirrorservice.org/sites/ftp.debian.org/debian/pool/main/g/grap/grap_1.45.orig.tar.gz"
  sha256 "906743cdccd029eee88a4a81718f9d0777149a3dc548672b3ef0ceaaf36a4ae0"

  bottle do
    rebuild 1
    sha256 "e3a1ad4346c17f8b1aa9197b6eca5e6ff78140c4db9e2894e86e5e6d0c1bc5e1" => :sierra
    sha256 "23d2d4dde1cebad798dcd76dca4b86f54f6ff3b379300d1fa216479e288bcb5e" => :el_capitan
  end

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          "--with-example-dir=#{pkgshare}/examples"
    system "make"
    ENV.deparallelize
    system "make", "install"
  end

  test do
    (testpath/"test.d").write <<-EOS.undent
      .G1
      54.2
      49.4
      49.2
      50.0
      48.2
      43.87
      .G2
    EOS
    system bin/"grap", testpath/"test.d"
  end
end
