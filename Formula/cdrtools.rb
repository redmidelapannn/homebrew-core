class Cdrtools < Formula
  desc "CD/DVD/Blu-ray premastering and recording software"
  homepage "http://cdrecord.org/"
  revision 1

  stable do
    url "https://downloads.sourceforge.net/project/cdrtools/cdrtools-3.01.tar.bz2"
    mirror "https://fossies.org/linux/misc/cdrtools-3.01.tar.bz2"
    sha256 "ed282eb6276c4154ce6a0b5dee0bdb81940d0cbbfc7d03f769c4735ef5f5860f"

    patch do
      url "https://downloads.sourceforge.net/project/cdrtools/cdrtools-3.01-fix-20151126-mkisofs-isoinfo.patch"
      sha256 "4e07a2be599c0b910ab3401744cec417dbdabf30ea867ee59030a7ad1906498b"
    end
  end

  bottle do
    rebuild 2
    sha256 "997521ac3566af71017dfe793b1fb5d4270ec3514975e390952e7881cc19dd37" => :high_sierra
    sha256 "f149ed36a825a0d0ff4b985e4ff13b826d6f823cb412080fe35aa08b88809cc5" => :sierra
    sha256 "2776db0006db92945d98b32fedf34a91d47ba619955e675a880e22ba3208d337" => :el_capitan
  end

  devel do
    url "https://downloads.sourceforge.net/project/cdrtools/alpha/cdrtools-3.02a09.tar.bz2"
    mirror "https://fossies.org/linux/misc/cdrtools-3.02a09.tar.bz2"
    sha256 "aa28438f458ef3f314b79f2029db27679dae1d5ffe1569b6de57742511915e81"
  end

  depends_on "smake" => :build

  conflicts_with "dvdrtools",
    :because => "both dvdrtools and cdrtools install binaries by the same name"

  def install
    # Speed-up the build by skipping the compilation of the profiled libraries.
    # This could be done by dropping each occurence of *_p.mk from the definition
    # of MK_FILES in every lib*/Makefile. But it is much easier to just remove all
    # lib*/*_p.mk files. The latter method produces warnings but works fine.
    rm_f Dir["lib*/*_p.mk"]
    system "smake", "INS_BASE=#{prefix}", "INS_RBASE=#{prefix}", "install"
    system "smake", "tests" if build.devel?
    # cdrtools tries to install some generic smake headers, libraries and
    # manpages, which conflict with the copies installed by smake itself
    (include/"schily").rmtree
    %w[libschily.a libdeflt.a libfind.a].each do |file|
      (lib/file).unlink
    end
    man5.rmtree
  end

  test do
    system "#{bin}/cdrecord", "-version"
    system "#{bin}/cdda2wav", "-version"
    date = shell_output("date")
    mkdir "subdir" do
      (testpath/"subdir/testfile.txt").write(date)
      system "#{bin}/mkisofs", "-r", "-o", "../test.iso", "."
    end
    assert_predicate testpath/"test.iso", :exist?
    system "#{bin}/isoinfo", "-R", "-i", "test.iso", "-X"
    assert_predicate testpath/"testfile.txt", :exist?
    assert_equal date, File.read("testfile.txt")
  end
end
