class Isync < Formula
  desc "Synchronize a maildir with an IMAP server"
  homepage "http://isync.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/isync/isync/1.2.1/isync-1.2.1.tar.gz"
  sha256 "e716de28c9a08e624a035caae3902fcf3b511553be5d61517a133e03aa3532ae"
  revision 1

  bottle do
    cellar :any
    sha256 "079e5fc96f11349d774180467f0792c69119f4c23c7df65177c4c133667dc1b1" => :el_capitan
    sha256 "37787a1460484fcf5538a2a00628155bd64ccf495e773eac447d690ba8cbcb41" => :yosemite
    sha256 "882fee8e20e7cb57d76569caeb13d71e001f15f7c9f1c2a53628911365633054" => :mavericks
  end

  head do
    url "git://git.code.sf.net/p/isync/isync"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
  end

  depends_on "berkeley-db"
  depends_on "openssl"

  def install
    system "./autogen.sh" if build.head?
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}",
                          "--disable-silent-rules"
    system "make", "install"
  end

  test do
    system bin/"get-cert", "duckduckgo.com:443"
  end
end
