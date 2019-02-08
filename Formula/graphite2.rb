class Graphite2 < Formula
  desc "Smart font renderer for non-Roman scripts"
  homepage "https://graphite.sil.org/"
  url "https://github.com/silnrsi/graphite/releases/download/1.3.13/graphite2-1.3.13.tgz"
  sha256 "dd63e169b0d3cf954b397c122551ab9343e0696fb2045e1b326db0202d875f06"
  head "https://github.com/silnrsi/graphite.git"

  bottle do
    cellar :any
    rebuild 1
    sha256 "2c78424efad440d8fcb5f1102058b7417c9bfbf9bec711f5f28a049a71450b96" => :mojave
    sha256 "a24ffdefedbbffad8c6950f4e9af4310109bf2d7dbb703e431eb14d291bcbe63" => :high_sierra
    sha256 "e619b0694a6182690572fc6db176f79ca3ceb0f5fbafb46c908f38203b5756e3" => :sierra
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
