class Jbigkit < Formula
  desc "JBIG1 data compression standard implementation"
  homepage "https://www.cl.cam.ac.uk/~mgk25/jbigkit/"
  url "https://www.cl.cam.ac.uk/~mgk25/jbigkit/download/jbigkit-2.1.tar.gz"
  mirror "https://mirrors.kernel.org/debian/pool/main/j/jbigkit/jbigkit_2.1.orig.tar.gz"
  sha256 "de7106b6bfaf495d6865c7dd7ac6ca1381bd12e0d81405ea81e7f2167263d932"

  head "https://www.cl.cam.ac.uk/~mgk25/git/jbigkit",
       :using => :git

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "0766ed390a58a3358c4890eb83e6ad06c865dec95ddaf5c21a4d980249f5ba5e" => :high_sierra
    sha256 "6abb2f50ad9d5157194e2a50237ecd1694b064ca32d65f64c59a34797cd5bace" => :sierra
    sha256 "5dc0d1435b9976c7245f6a70464814b6fda7f2a8e501e0ef55978935dac15042" => :el_capitan
  end

  option "with-test", "Verify the library during install"

  deprecated_option "with-check" => "with-test"

  conflicts_with "netpbm", :because => "both install `pbm.5` and `pgm.5` files"

  def install
    system "make", "CC=#{ENV.cc}", "CCFLAGS=#{ENV.cflags}"

    if build.with? "test"
      # It needs j1 to make the tests happen in sequence.
      ENV.deparallelize
      system "make", "test"
    end

    cd "pbmtools" do
      bin.install %w[pbmtojbg jbgtopbm pbmtojbg85 jbgtopbm85]
      man1.install %w[pbmtojbg.1 jbgtopbm.1]
      man5.install %w[pbm.5 pgm.5]
    end
    cd "libjbig" do
      lib.install Dir["lib*.a"]
      (prefix/"src").install Dir["j*.c", "j*.txt"]
      include.install Dir["j*.h"]
    end
    pkgshare.install "examples", "contrib"
  end

  test do
    system "#{bin}/jbgtopbm #{pkgshare}/examples/ccitt7.jbg | #{bin}/pbmtojbg - testoutput.jbg"
    system "/usr/bin/cmp", pkgshare/"examples/ccitt7.jbg", "testoutput.jbg"
  end
end
