class Graphite2 < Formula
  desc "Smart font renderer for non-Roman scripts"
  homepage "http://graphite.sil.org"
  url "https://github.com/silnrsi/graphite/releases/download/1.3.12/graphite2-1.3.12.tgz"
  sha256 "cd9530c16955c181149f9af1f13743643771cb920c75a04c95c77c871a2029d0"
  head "https://github.com/silnrsi/graphite.git"

  bottle do
    cellar :any
    rebuild 1
    sha256 "a27904ec1c3407a8c4dd98ea391b8949832bcd27c5ba4c19dface10701032065" => :mojave
    sha256 "3ff056016f8ee1e1e86b138234b4fc7c97b62d8022f8e255ae99289fc8590b42" => :high_sierra
    sha256 "07fe554e86e7cc284e5b012dba97157cca9efec0b9ca04f40066daeda3002905" => :sierra
    sha256 "2972531164be36e1d3693caec0cf315621b9ca7723bf6cdba9259e793fc2add8" => :el_capitan
  end

  depends_on "cmake" => :build

  needs :cxx11

  resource "testfont" do
    url "https://scripts.sil.org/pub/woff/fonts/Simple-Graphite-Font.ttf"
    sha256 "7e573896bbb40088b3a8490f83d6828fb0fd0920ac4ccdfdd7edb804e852186a"
  end

  def install
    system "cmake", *std_cmake_args
    system "make", "install"
  end

  test do
    resource("testfont").stage do
      shape = shell_output("#{bin}/gr2fonttest Simple-Graphite-Font.ttf 'abcde'")
      assert_match /67.*36.*37.*38.*71/m, shape
    end
  end
end
