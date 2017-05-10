class WithReadline < Formula
  desc "Allow GNU Readline to be used with arbitrary programs"
  homepage "https://www.greenend.org.uk/rjk/sw/withreadline.html"
  url "https://www.greenend.org.uk/rjk/sw/with-readline-0.1.1.tar.gz"
  sha256 "d12c71eb57ef1dbe35e7bd7a1cc470a4cb309c63644116dbd9c88762eb31b55d"
  revision 1

  bottle do
    cellar :any
    rebuild 1
    sha256 "3c02bb924055f04523c914f593920789d11f89eff15ea062948d6be5e736df60" => :sierra
    sha256 "ed66a1895a952728e4c8d494cb3a25d4308f5f80f2eaf975460755c4251d2778" => :el_capitan
    sha256 "27925c3630796329ae6ffc6492e4d4087952a9a45dde56689c962c6cce78abbc" => :yosemite
  end

  depends_on "readline"

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    pipe_output("#{bin}/with-readline /usr/bin/expect", "exit", 0)
  end
end
