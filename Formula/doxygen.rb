class Doxygen < Formula
  desc "Generate documentation for several programming languages"
  homepage "http://www.doxygen.org/"
  url "http://doxygen.nl/files/doxygen-1.8.17.src.tar.gz"
  mirror "https://downloads.sourceforge.net/project/doxygen/rel-1.8.17/doxygen-1.8.17.src.tar.gz"
  sha256 "2cba988af2d495541cbbe5541b3bee0ee11144dcb23a81eada19f5501fd8b599"
  head "https://github.com/doxygen/doxygen.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 2
    sha256 "3e6c49a9b2fc1df9fa60f72c95c7f5ebdea5baf0e85a9c4928e67346878c148d" => :catalina
    sha256 "4773188fa61fc97ad9024668916aea105513ea98dad98657e46b6d055c7d7cc2" => :mojave
    sha256 "d505067edf68316ae78449b5de18f37eee42d40da2e38704e45aad3cdc24ad55" => :high_sierra
  end

  depends_on "bison" => :build
  depends_on "cmake" => :build

  def install
    args = std_cmake_args + %W[
      -DCMAKE_OSX_DEPLOYMENT_TARGET:STRING=#{MacOS.version}
    ]

    mkdir "build" do
      system "cmake", "..", *args
      system "make"
    end
    bin.install Dir["build/bin/*"]
    man1.install Dir["doc/*.1"]
  end

  test do
    system "#{bin}/doxygen", "-g"
    system "#{bin}/doxygen", "Doxyfile"
  end
end
