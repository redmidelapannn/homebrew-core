class Direvent < Formula
  desc "Monitors events in the file system directories"
  homepage "https://www.gnu.org.ua/software/direvent/direvent.html"
  url "https://ftp.gnu.org/gnu/direvent/direvent-5.1.tar.gz"
  mirror "https://ftpmirror.gnu.org/direvent/direvent-5.1.tar.gz"
  sha256 "c461600d24183563a4ea47c2fd806037a43354ea68014646b424ac797a959bdb"

  bottle do
    rebuild 1
    sha256 "2e57caeae0206a3e5def9caa50dce1351fb2334eea0e4250556a2b8bd0e65a72" => :high_sierra
    sha256 "880b41066ee8a9d7c091042c39d629176362926dd4fe29e0dbbb445de041a0c1" => :sierra
    sha256 "4570a29fbbb9a95de232848cdb2207fcb9c5fe15891c7fb2321113470e136c45" => :el_capitan
  end

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make"
    system "make", "check"
    system "make", "install"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/direvent --version")
  end
end
