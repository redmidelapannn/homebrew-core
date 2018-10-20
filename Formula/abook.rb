class Abook < Formula
  desc "Address book with mutt support"
  homepage "https://abook.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/abook/abook/0.5.6/abook-0.5.6.tar.gz"
  sha256 "0646f6311a94ad3341812a4de12a5a940a7a44d5cb6e9da5b0930aae9f44756e"
  revision 1
  head "https://git.code.sf.net/p/abook/git.git"

  bottle do
    rebuild 1
    sha256 "b72177e86ac2a9fbbc3541374c296d9841a42a73c4150e96160617c910e9e16a" => :mojave
    sha256 "fa09fe607c2b60760f7d5b133a4689d2ae7bd5c70963aab5daa5be25badefede" => :high_sierra
    sha256 "61c75529f187a65ec5158a06e82f4227ff5a6bfba59c921776fb2bb692a78ee3" => :sierra
  end

  depends_on "readline"

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}"
    system "make", "install"
  end

  test do
    system "#{bin}/abook", "--formats"
  end
end
