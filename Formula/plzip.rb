class Plzip < Formula
  desc "Data compressor"
  homepage "http://www.nongnu.org/lzip/plzip.html"
  url "http://download.savannah.gnu.org/releases/lzip/plzip/plzip-1.4.tar.gz"
  sha256 "2a152ee429495cb96c22a51b618d1d19882db3e24aff79329d9c755a2a2f67bb"

  bottle do
    cellar :any_skip_relocation
    revision 1
    sha256 "23e72d690f7e1984510c109a1076450df7604d012253c32d4cb028204d5455eb" => :el_capitan
    sha256 "0029fa7acfff575a49bb00fa99f77ab77793c401ed2f7fcc0e9ba75c501c7951" => :yosemite
    sha256 "242789875b4ac168ce5fb3b12911a378ccf6ece94c090d24bbe049d07efb2295" => :mavericks
  end

  devel do
    url "http://download.savannah.gnu.org/releases/lzip/plzip/plzip-1.5-rc2.tar.lz"
    sha256 "3b4ba622875f33d124ddf79f13ad3ff0fb977fec078f1fd6e88f0432515472f5"
  end

  depends_on "lzlib"

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make", "check"
    ENV.deparallelize
    system "make", "install"
  end

  test do
    text = "Hello Homebrew!"
    compressed = pipe_output("#{bin}/plzip -c", text)
    assert_equal text, pipe_output("#{bin}/plzip -d", compressed)
  end
end
