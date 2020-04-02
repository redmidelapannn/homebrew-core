class Graphite2 < Formula
  desc "Smart font renderer for non-Roman scripts"
  homepage "https://graphite.sil.org/"
  url "https://github.com/silnrsi/graphite/releases/download/1.3.14/graphite2-1.3.14.tgz"
  sha256 "f99d1c13aa5fa296898a181dff9b82fb25f6cc0933dbaa7a475d8109bd54209d"
  head "https://github.com/silnrsi/graphite.git"

  bottle do
    cellar :any
    sha256 "13234219e51b31f1df47a037a07b5bc6c3c46d633a2b01de7a1b4c09f77be86f" => :catalina
    sha256 "d4ac0f5bd40633559ed80afbed390adc236e31c78914500cd0a9e702980c1535" => :mojave
    sha256 "1142c73cd2a17d91532cfa210c8b766f5508a8a8f23c40f7aff9e7c477291563" => :high_sierra
  end

  depends_on "cmake" => :build

  resource "testfont" do
    url "https://scripts.sil.org/pub/woff/fonts/Simple-Graphite-Font.ttf"
    sha256 "7e573896bbb40088b3a8490f83d6828fb0fd0920ac4ccdfdd7edb804e852186a"
  end

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end

  test do
    resource("testfont").stage do
      shape = shell_output("#{bin}/gr2fonttest Simple-Graphite-Font.ttf 'abcde'")
      assert_match /67.*36.*37.*38.*71/m, shape
    end
  end
end
