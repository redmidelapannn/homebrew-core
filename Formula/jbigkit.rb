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
    sha256 "a68f609d62f80b852578f699fee99beadc25d5597227a0c040cca3014158aa96" => :sierra
    sha256 "b3a950a35896823a2b02500e70ef8aed21b811a79a04e4607cd19ac4fefbb810" => :el_capitan
    sha256 "c9716c4094b0248407466fedc5e3d1ef2b4636a0663f65df50864eb652241e1e" => :yosemite
  end

  option "with-test", "Verify the library during install"

  deprecated_option "with-check" => "with-test"

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
