class Grap < Formula
  desc "Language for typesetting graphs"
  homepage "http://www.lunabase.org/~faber/Vault/software/grap/"
  url "http://www.lunabase.org/~faber/Vault/software/grap/grap-1.45.tar.gz"
  sha256 "906743cdccd029eee88a4a81718f9d0777149a3dc548672b3ef0ceaaf36a4ae0"

  bottle do
    rebuild 1
    sha256 "7eed951be5eba010abc01c3aba64b107d0dabab93dc63a18c3db03a474404848" => :sierra
    sha256 "cc3ca92573383f8b31341c2effadb4a0bd42642ee0aa7945616a16b567c05096" => :el_capitan
    sha256 "e31dd8e0d424b9de7d86fcd562d22b260977190eab3ff1f24ca0704ec9c309cd" => :yosemite
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
