class Rhash < Formula
  desc "Utility for computing and verifying hash sums of files"
  homepage "https://sourceforge.net/projects/rhash/"
  url "https://downloads.sourceforge.net/project/rhash/rhash/1.3.8/rhash-1.3.8-src.tar.gz"
  sha256 "be536a56acfefc87dbc8b1db30fc639020e41edf05518185ea98630e3df7c04c"
  head "https://github.com/rhash/RHash.git"

  bottle do
    cellar :any
    rebuild 1
    sha256 "440cbf641f5378e555065b061787074248aeda6c5fd690a62da1e08195e05927" => :catalina
    sha256 "344455ebbae2259359d1a07fc4a03248e147e01bc6b737dd577b45cfcf62053a" => :mojave
    sha256 "65e9c6beae7054b526809ef10992d536522147c77bbe55fce83bfd844ab30c9c" => :high_sierra
  end

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make", "install"
    lib.install "librhash/librhash.dylib"
    system "make", "-C", "librhash", "install-lib-headers"
  end

  test do
    (testpath/"test").write("test")
    (testpath/"test.sha1").write("a94a8fe5ccb19ba61c4c0873d391e987982fbbd3 test")
    system "#{bin}/rhash", "-c", "test.sha1"
  end
end
