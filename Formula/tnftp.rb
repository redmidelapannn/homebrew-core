class Tnftp < Formula
  desc "This is the FTP client that used to be included in MacOS prior to High Sierra"
  homepage "http://freecode.com/projects/tnftp"
  url "ftp://ftp.netbsd.org/pub/NetBSD/misc/tnftp/tnftp-20091122.tar.gz"
  sha256 "ad834fa8776d6be87aa438c554869301173a0808919c65a84dccea6c5ec9d286"

  bottle do
    cellar :any_skip_relocation
    sha256 "4e639984cf340a15bd5c555acd851c53305b629d2cb1eeb0fcd6a4b525953dae" => :high_sierra
    sha256 "a9eb32dc443f782de17844b2332c3217ec6d4f7d05c8fbb5c2e8d402d9658dae" => :sierra
    sha256 "6273d4f510e8ba2df0abed7fda1ded17b60fc764003a7abf38d725b0ff37440e" => :el_capitan
  end

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    output = shell_output("#{bin}/tnftp about:version", 0)
    assert_match "Version: tnftp 20091122", output
  end
end
