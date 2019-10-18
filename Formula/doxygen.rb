class Doxygen < Formula
  desc "Generate documentation for several programming languages"
  homepage "http://www.doxygen.org/"
  url "http://doxygen.nl/files/doxygen-1.8.16.src.tar.gz"
  mirror "https://downloads.sourceforge.net/project/doxygen/rel-1.8.16/doxygen-1.8.16.src.tar.gz"
  sha256 "ff981fb6f5db4af9deb1dd0c0d9325e0f9ba807d17bd5750636595cf16da3c82"
  head "https://github.com/doxygen/doxygen.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "90397fbb465c1f01b1fc8d8b57a9c725f30a59ced55079a0f674d77d0f2bd522" => :catalina
    sha256 "9c580acef252ff6cdc6327227f85bb492a949c30a08fa2d975591631d8b48c23" => :mojave
    sha256 "88ca6c445feed6210887188270294724053733aa77ca12ab4ec10ad47ea3ab67" => :high_sierra
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
