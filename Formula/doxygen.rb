class Doxygen < Formula
  desc "Generate documentation for several programming languages"
  homepage "http://www.doxygen.org/"
  url "https://ftp.stack.nl/pub/users/dimitri/doxygen-1.8.11.src.tar.gz"
  mirror "https://downloads.sourceforge.net/project/doxygen/rel-1.8.11/doxygen-1.8.11.src.tar.gz"
  sha256 "65d08b46e48bd97186aef562dc366681045b119e00f83c5b61d05d37ea154049"
  head "https://github.com/doxygen/doxygen.git"

  bottle do
    cellar :any_skip_relocation
    revision 2
    sha256 "28d975e55b10175f82dcd0b89c4a3d010a86b4f27f57bc5d37bfee0b44d60d7c" => :el_capitan
    sha256 "605d4080b81750960ab2b8b42a51d4345ae16f0bf74c66132c6f8e1db35e8aef" => :yosemite
    sha256 "fcd13366c726642f07e5f0ba6cd6dc1246d54721d781193e1fb1eb961a30f3f8" => :mavericks
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
    args = std_cmake_args
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
