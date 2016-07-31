class ClangFormat < Formula
  desc "Formatting tools for C, C++, Obj-C, Java, JavaScript, TypeScript"
  homepage "http://clang.llvm.org/docs/ClangFormat.html"
  version "2016-06-27"

  stable do
    url "http://llvm.org/svn/llvm-project/llvm/tags/google/stable/2016-06-27/", :using => :svn

    resource "clang" do
      url "http://llvm.org/svn/llvm-project/cfe/tags/google/stable/2016-06-27/", :using => :svn
    end

    resource "libcxx" do
      url "http://llvm.org/releases/3.8.0/libcxx-3.8.0.src.tar.xz"
      sha256 "36804511b940bc8a7cefc7cb391a6b28f5e3f53f6372965642020db91174237b"
    end
  end

  bottle do
    cellar :any_skip_relocation
    revision 1
    sha256 "45f3a9c197dfb2625d13bea8e4835b9e556e61eba526b13f468a268dab970b6f" => :el_capitan
    sha256 "e3a27ce32057786d6f953d9f2c31d81b36dd8e11d3bfe7dd90d76acc9ca6df9d" => :yosemite
    sha256 "302fed5a96aab44159b73f57e7dbcbd43ed69247c66da78b9c0a35e51c18d01f" => :mavericks
  end

  head do
    url "http://llvm.org/svn/llvm-project/llvm/trunk/", :using => :svn

    resource "clang" do
      url "http://llvm.org/svn/llvm-project/cfe/trunk/", :using => :svn
    end

    resource "libcxx" do
      url "http://llvm.org/releases/3.8.0/libcxx-3.8.0.src.tar.xz"
      sha256 "36804511b940bc8a7cefc7cb391a6b28f5e3f53f6372965642020db91174237b"
    end
  end

  depends_on "cmake" => :build
  depends_on "ninja" => :build
  depends_on "subversion" => :build

  def install
    (buildpath/"projects/libcxx").install resource("libcxx")
    (buildpath/"tools/clang").install resource("clang")

    mkdir "build" do
      args = std_cmake_args
      args << "-DCMAKE_OSX_SYSROOT=/" unless MacOS::Xcode.installed?
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
