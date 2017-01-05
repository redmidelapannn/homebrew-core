class Doxygen < Formula
  desc "Generate documentation for several programming languages"
  homepage "http://www.doxygen.org/"
  url "https://ftp.stack.nl/pub/users/dimitri/doxygen-1.8.13.src.tar.gz"
  sha256 "af667887bd7a87dc0dbf9ac8d86c96b552dfb8ca9c790ed1cbffaa6131573f6b"
  head "https://github.com/doxygen/doxygen.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "28e9ca7ec0576dc74b7cbb112eba4a65984fe3c6e042fc5e1d7ebdb8640d3e8b" => :sierra
    sha256 "e2a72fc96d25087f6e79b05bf32c4c4fe68e87049fe5b61fceea047cce260a13" => :el_capitan
    sha256 "b9c65ec6edd5af0dd3ac24f3e183b9c208ad7b602b50222f073cfa9a0c6e1c9b" => :yosemite
  end

  option "with-graphviz", "Build with dot command support from Graphviz."
  option "with-qt5", "Build GUI frontend with Qt support."
  option "with-llvm", "Build with libclang support."

  deprecated_option "with-dot" => "with-graphviz"
  deprecated_option "with-doxywizard" => "with-qt5"
  deprecated_option "with-libclang" => "with-llvm"

  depends_on "cmake" => :build
  depends_on "graphviz" => :optional
  depends_on "qt5" => :optional
  depends_on "llvm" => :optional

  def install
    args = std_cmake_args << "-DCMAKE_OSX_DEPLOYMENT_TARGET:STRING=#{MacOS.version}"
    args << "-Dbuild_wizard=ON" if build.with? "qt5"
    args << "-Duse_libclang=ON -DLLVM_CONFIG=#{Formula["llvm"].opt_bin}/llvm-config" if build.with? "llvm"

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
