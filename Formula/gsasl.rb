class Gsasl < Formula
  desc "SASL library command-line interface"
  homepage "https://www.gnu.org/software/gsasl/"
  url "https://ftpmirror.gnu.org/gsasl/gsasl-1.8.0.tar.gz"
  mirror "https://ftp.gnu.org/gnu/gsasl/gsasl-1.8.0.tar.gz"
  sha256 "310262d1ded082d1ceefc52d6dad265c1decae8d84e12b5947d9b1dd193191e5"

  bottle do
    cellar :any
    rebuild 3
    sha256 "9f58d619a575245715284da05873bde67c3accb514aec4b531362da723efddf1" => :sierra
    sha256 "a866f7c78e97feee6a91c9b48b2b1322cbd6f5a992bd1275119e3b28f3adc46e" => :el_capitan
    sha256 "b6358f2d1d834785141566d3a8c9e1a387148d3b5542f655e07419b5ec21ee75" => :yosemite
  end

  depends_on "libntlm" => :optional

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--with-gssapi-impl=mit",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    assert_match /#{version}/, shell_output("#{bin}/gsasl")
  end
end
