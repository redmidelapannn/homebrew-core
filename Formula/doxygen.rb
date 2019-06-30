class Doxygen < Formula
  desc "Generate documentation for several programming languages"
  homepage "http://www.doxygen.org/"
  head "https://github.com/doxygen/doxygen.git"

  stable do
    url "http://doxygen.nl/files/doxygen-1.8.15.src.tar.gz"
    mirror "https://downloads.sourceforge.net/project/doxygen/rel-1.8.15/doxygen-1.8.15.src.tar.gz"
    sha256 "bd9c0ec462b6a9b5b41ede97bede5458e0d7bb40d4cfa27f6f622eb33c59245d"

    # Fix build breakage for 1.8.15 and CMake 3.13
    # https://github.com/Homebrew/homebrew-core/issues/35815
    patch do
      url "https://github.com/doxygen/doxygen/commit/889eab308b564c4deba4ef58a3f134a309e3e9d1.diff?full_index=1"
      sha256 "ba4f9251e2057aa4da3ae025f8c5f97ea11bf26065a3f0e3b313b9acdad0b938"
    end
  end

  bottle do
    cellar :any_skip_relocation
    rebuild 3
    sha256 "1876406cc86b22010deaca4e5bf3016b637c69dbd05a39d2061f6ef3c2b06980" => :mojave
    sha256 "2d0b0e7479239cc8817db37f7d44fee49d0fa0ea9e39adc4989039f4d253fa4e" => :high_sierra
    sha256 "3beb42b71ee1b508381feff494144951a3a1730a59dfe47ed7463176f75a6030" => :sierra
  end

  depends_on "bison" => :build if build.head?
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
