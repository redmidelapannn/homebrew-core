class ClangFormatAT38 < Formula
  desc "Formatting tools for C/C++/ObjC/Java/JavaScript/TypeScript"
  homepage "https://clang.llvm.org/docs/ClangFormat.html"
  url "https://llvm.org/releases/3.8.0/llvm-3.8.0.src.tar.xz"
  sha256 "555b028e9ee0f6445ff8f949ea10e9cd8be0d084840e21fbbe1d31d51fc06e46"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "505abba81c60d2ed51e1e70892357892b0e4ea459ec131971c2b13c7f6091fc3" => :sierra
    sha256 "1f90904dc2042ee78c76e83b1ea92971d4438b31a8b2d3e2ab5bf33e0d079189" => :el_capitan
    sha256 "2aff56ca0c4d9a31f167bee62f527dbe1da9f0fab1912b06a8155ed13a4b1896" => :yosemite
  end

  keg_only :versioned_formula

  depends_on "cmake" => :build
  depends_on "ninja" => :build
  depends_on "subversion" => :build

  resource "clang" do
    url "https://llvm.org/releases/3.8.0/cfe-3.8.0.src.tar.xz"
    sha256 "04149236de03cf05232d68eb7cb9c50f03062e339b68f4f8a03b650a11536cf9"
  end

  resource "libcxx" do
    url "https://llvm.org/releases/3.8.0/libcxx-3.8.0.src.tar.xz"
    sha256 "36804511b940bc8a7cefc7cb391a6b28f5e3f53f6372965642020db91174237b"
  end

  def install
    (buildpath/"projects/libcxx").install resource("libcxx")
    (buildpath/"tools/clang").install resource("clang")

    mkdir "build" do
      args = std_cmake_args
      args << "-DLLVM_ENABLE_LIBCXX=ON"
      args << ".."
      system "cmake", "-G", "Ninja", *args
      system "ninja", "clang-format"
      bin.install "bin/clang-format"
    end
    bin.install "tools/clang/tools/clang-format/git-clang-format"
    (share/"clang").install Dir["tools/clang/tools/clang-format/clang-format*"]
  end

  test do
    # NB: below C code is messily formatted on purpose.
    (testpath/"test.c").write <<-EOS
      int         main(char *args) { \n   \t printf("hello"); }
    EOS

    assert_equal "int main(char *args) { printf(\"hello\"); }\n",
        shell_output("#{bin}/clang-format -style=Google test.c")
  end
end
