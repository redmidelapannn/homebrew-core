class SourceHighlight < Formula
  desc "Source-code syntax highlighter"
  homepage "https://www.gnu.org/software/src-highlite/"
  url "https://ftp.gnu.org/gnu/src-highlite/source-highlight-3.1.8.tar.gz"
  mirror "https://ftpmirror.gnu.org/src-highlite/source-highlight-3.1.8.tar.gz"
  mirror "https://fossies.org/linux/www/source-highlight-3.1.8.tar.gz"
  sha256 "01336a7ea1d1ccc374201f7b81ffa94d0aecb33afc7d6903ebf9fbf33a55ada3"
  revision 9

  bottle do
    rebuild 1
    sha256 "36feb85b625aac06f6f761606f644b43f9001355284b2515820952a1a39a9684" => :mojave
    sha256 "3901c2ba253bc6c89839031b918d31ae91b97e24071272543861fbeb975e8720" => :high_sierra
    sha256 "6915f1a3a64216d4b9644b29a48a77e6ef29a62a558f8c6de2f4cd9df7294385" => :sierra
    sha256 "ea65b864d9d18468004f37569373cbdeb3c9047e130ba4f24da03899a26a3dba" => :el_capitan
  end

  depends_on "boost"

  needs :cxx11

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--with-boost=#{HOMEBREW_PREFIX}"
    system "make", "install"

    bash_completion.install "completion/source-highlight"
  end

  test do
    assert_match /GNU Source-highlight #{version}/, shell_output("#{bin}/source-highlight -V")
  end
end
