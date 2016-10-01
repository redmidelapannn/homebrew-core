class SourceHighlight < Formula
  desc "Source-code syntax highlighter"
  homepage "https://www.gnu.org/software/src-highlite/"
  url "https://ftpmirror.gnu.org/src-highlite/source-highlight-3.1.8.tar.gz"
  mirror "https://ftp.gnu.org/gnu/src-highlite/source-highlight-3.1.8.tar.gz"
  mirror "http://mirror.anl.gov/pub/gnu/src-highlite/source-highlight-3.1.8.tar.gz"
  sha256 "01336a7ea1d1ccc374201f7b81ffa94d0aecb33afc7d6903ebf9fbf33a55ada3"
  revision 3

  bottle do
    sha256 "857d388f45a7f8fd8c3186f634cec37b4c72287e5951b66b11bd3c3e2931b214" => :sierra
    sha256 "95dd52fac74dd4d7ccb19e908b4ab172a3d5c527dc1ab647af6c0ad510a28d72" => :el_capitan
    sha256 "9d1d31f150cfc2a02bc6fe9bbb16441cc7ec5dc129133dd80e95796e42727d6f" => :yosemite
  end

  depends_on "boost@1.61"

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
