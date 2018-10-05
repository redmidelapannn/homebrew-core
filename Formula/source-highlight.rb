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
    sha256 "b886e8e808a58d0bcf88d20152d8f098a458f96a6bb5ce32857a4780a3076e3f" => :mojave
    sha256 "3b06c9972f0518c33c999c76e6e987caa08fe72964f09d7cbac2023200f60e1f" => :high_sierra
    sha256 "8d1e140399ef0de81def705de6847015350904acc49a062ded0213feef67e5b5" => :sierra
  end

  depends_on "boost"

  needs :cxx11

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--with-boost=#{Formula["boost"].opt_prefix}"
    system "make", "install"

    bash_completion.install "completion/source-highlight"
  end

  test do
    assert_match /GNU Source-highlight #{version}/, shell_output("#{bin}/source-highlight -V")
  end
end
