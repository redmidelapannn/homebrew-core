class Rhash < Formula
  desc "Utility for computing and verifying hash sums of files"
  homepage "https://sourceforge.net/projects/rhash/"
  url "https://downloads.sourceforge.net/project/rhash/rhash/1.3.8/rhash-1.3.8-src.tar.gz"
  sha256 "be536a56acfefc87dbc8b1db30fc639020e41edf05518185ea98630e3df7c04c"
  head "https://github.com/rhash/RHash.git"

  bottle do
    cellar :any
    rebuild 1
    sha256 "0db0c8b5b90deee9c29b6e2e10620a81510b111f9817a32f2c5f3641cc274209" => :catalina
    sha256 "f396b4e278ec2c5b758212d6c063ec5ae450a694b6d95b1108954296b205f11e" => :mojave
    sha256 "55c679e1c567d81b489ef9fc8bbc5619bd47f28bdd550b5bc4b44675eebac1e2" => :high_sierra
  end

  def install
    # Work around Xcode 11 code generation bug
    ENV.append_to_cflags "-fno-stack-check" if DevelopmentTools.clang_build_version >= 1010

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
