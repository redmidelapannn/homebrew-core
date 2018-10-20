class Cdrtools < Formula
  desc "CD/DVD/Blu-ray premastering and recording software"
  homepage "http://cdrecord.org/"
  url "https://downloads.sourceforge.net/project/cdrtools/cdrtools-3.01.tar.bz2"
  mirror "https://fossies.org/linux/misc/cdrtools-3.01.tar.bz2"
  sha256 "ed282eb6276c4154ce6a0b5dee0bdb81940d0cbbfc7d03f769c4735ef5f5860f"
  revision 1

  bottle do
    rebuild 2
    sha256 "d176c15470641c74f79b8183a430b23224f22116225033a5ee614a51a89412ba" => :mojave
    sha256 "6c552a032a4897528fd888b1c5d8ca5ff54f136bc0232d867a5741945c6c8f5d" => :high_sierra
    sha256 "abf6caf272a4fb692b7e59da353f4f6266ba2846c2f9298983c5173b3a87a320" => :sierra
  end

  depends_on "smake" => :build

  conflicts_with "dvdrtools",
    :because => "both dvdrtools and cdrtools install binaries by the same name"

  patch do
    url "https://downloads.sourceforge.net/project/cdrtools/cdrtools-3.01-fix-20151126-mkisofs-isoinfo.patch"
    sha256 "4e07a2be599c0b910ab3401744cec417dbdabf30ea867ee59030a7ad1906498b"
  end

  def install
    # Speed-up the build by skipping the compilation of the profiled libraries.
    # This could be done by dropping each occurence of *_p.mk from the definition
    # of MK_FILES in every lib*/Makefile. But it is much easier to just remove all
    # lib*/*_p.mk files. The latter method produces warnings but works fine.
    rm_f Dir["lib*/*_p.mk"]
    system "smake", "INS_BASE=#{prefix}", "INS_RBASE=#{prefix}", "install"
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
