class Konoha < Formula
  desc "Static scripting language with extensible syntax"
  homepage "https://github.com/konoha-project/konoha3"
  url "https://github.com/konoha-project/konoha3/archive/v0.1.tar.gz"
  sha256 "e7d222808029515fe229b0ce1c4e84d0a35b59fce8603124a8df1aeba06114d3"
  revision 3

  bottle do
    rebuild 1
    sha256 "da98f3c2562e562560cfeadaea82f83db9c2fac53a16d0d80977115ea75b0360" => :high_sierra
    sha256 "f807d1384ea744744fde39bef026b869ac91f597fc93250ba5a61b582c59ea29" => :sierra
    sha256 "eaa9b5edf7dac0b0076ccbc6b39738943390b38f0b0ae1c291dfd5c16ba78806" => :el_capitan
  end

  head do
    url "https://github.com/konoha-project/konoha3.git"

    depends_on "openssl"
  end

  depends_on "cmake" => :build
  depends_on "json-c"
  depends_on "mecab" if MacOS.version >= :mountain_lion
  depends_on "open-mpi"
  depends_on "pcre"
  depends_on "python@2"
  depends_on "sqlite"

  def install
    mkdir "build" do
      system "cmake", "..", *std_cmake_args
      system "make"
      system "make", "install"
    end
  end

  test do
    (testpath/"test").write "System.p(\"Hello World!\");"
    output = shell_output("#{bin}/konoha #{testpath}/test")
    assert_match "(test:1) Hello World!", output
  end
end
