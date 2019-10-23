class Fdm < Formula
  desc "Fetch and deliver mail based on a ruleset"
  homepage "https://github.com/nicm/fdm"
  url "https://github.com/nicm/fdm/releases/download/2.0/fdm-2.0.tar.gz"
  sha256 "06b28cb6b792570bc61d7e29b13d2af46b92fea77e058b2b17e11e8f7ed0cea4"

  bottle do
    cellar :any
    sha256 "c5b128c154604f5f2af18c2e4799f4a0b1e3577d28ceec071403b3b5648427bd" => :catalina
    sha256 "d9778135ad2965c20c34065e3441a675efed74f2a10cfdeb94de055d64fe744a" => :mojave
    sha256 "0be1de236753f148cea46b05256c265e0cf1f5ed65efe9937a2a2e02d7e9d173" => :high_sierra
  end

  depends_on "openssl@1.1"
  depends_on "pcre"
  depends_on "tdb"

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--enable-pcre",
                          "--prefix=#{prefix}"
    system "make", "install"
    doc.install "MANUAL"
  end

  test do
    path = testpath/"fdm.conf"
    path.write <<~EOS
      account "stdin" stdin
      cache "#{testpath}/fdm.cache"
    EOS
    system "cat", testpath/"fdm.conf"
    system bin/"fdm", "-f", testpath/"fdm.conf", "cache", "add", testpath/"fdm.cache", "test"
    assert_match /#{testpath}\/fdm.cache: 1 keys/, shell_output("#{bin}/fdm -f #{testpath}/fdm.conf cache list #{testpath}/fdm.cache")
  end
end
