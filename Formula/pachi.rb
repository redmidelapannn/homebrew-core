class Pachi < Formula
  desc "Software for the Board Game of Go/Weiqi/Baduk"
  homepage "http://pachi.or.cz/"
  url "http://repo.or.cz/w/pachi.git/snapshot/pachi-11.00-retsugen.tar.gz"
  sha256 "2aaf9aba098d816d20950d283c8eaed522f3fa71f68390a4c384c0c1ab03cd6f"
  revision 1
  head "https://github.com/pasky/pachi.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "9c9089aaa388d52dcc6872ef7bf1b06ba07880d61c486faa7d907bd5c0f6360e" => :mojave
    sha256 "a84858351b6d26561da0521d6bcb4c53ef175057ea572225b076d4aefc9b3140" => :high_sierra
    sha256 "c9495d1239771b86d3bdfb06304e6ca71b29fabf77bb4195a3eb703f08603456" => :sierra
    sha256 "be8204fca179a2882794761e115e3004591ba4cdc43306f31cdadff1ba1add6e" => :el_capitan
  end

  fails_with :clang if MacOS.version <= :mavericks

  resource "patterns" do
    url "https://sainet-dist.s3.amazonaws.com/pachi_patterns.zip"
    sha256 "73045eed2a15c5cb54bcdb7e60b106729009fa0a809d388dfd80f26c07ca7cbc"
  end

  resource "book" do
    url "https://gnugo.baduk.org/books/ra6.zip"
    sha256 "1e7ffc75c424e94338308c048aacc479da6ac5cbe77c0df8adc733956872485a"
  end

  def install
    ENV["MAC"] = "1"
    ENV["DOUBLE_FLOATING"] = "1"

    system "make"
    bin.install "pachi"

    pkgshare.install resource("patterns")
    pkgshare.install resource("book")
  end

  def caveats; <<~EOS
    This formula also downloads additional data, such as opening books
    and pattern files. They are stored in #{opt_pkgshare}.

    At present, pachi cannot be pointed to external files, so make sure
    to set the working directory to #{opt_pkgshare} if you want pachi
    to take advantage of these additional files.
  EOS
  end

  test do
    assert_match /^= [A-T][0-9]+$/, pipe_output("#{bin}/pachi", "genmove b\n", 0)
  end
end
