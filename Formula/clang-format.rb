class ClangFormat < Formula
  desc "Formatting tools for C, C++, Obj-C, Java, JavaScript, TypeScript"
  homepage "https://clang.llvm.org/docs/ClangFormat.html"
  version "2018-12-18"

  stable do
    depends_on "subversion" => :build
    url "https://llvm.org/svn/llvm-project/llvm/tags/google/stable/2018-12-18/", :using => :svn

    resource "clang" do
      url "https://llvm.org/svn/llvm-project/cfe/tags/google/stable/2018-12-18/", :using => :svn
    end

    resource "libcxx" do
      url "https://releases.llvm.org/7.0.0/libcxx-7.0.0.src.tar.xz"
      sha256 "9b342625ba2f4e65b52764ab2061e116c0337db2179c6bce7f9a0d70c52134f0"
    end
  end

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "e40bd6fd85dcca3b30c6d367a11fba19a70b21ad432f7ce120a21b5f74083062" => :mojave
    sha256 "34cb2060303f0f1580ff775e11f8ae429d8f3e881af7104cf1bf8faf5ea7afb6" => :high_sierra
    sha256 "df9241f8c1c5e99a10097ac3c2d7ac3e7b2dd397cb9231874fa70dfe4e004120" => :sierra
  end

  head do
    url "https://git.llvm.org/git/llvm.git"

    resource "clang" do
      url "https://git.llvm.org/git/clang.git"
    end

    resource "libcxx" do
      url "https://git.llvm.org/git/libcxx.git"
    end
  end

  depends_on "cmake" => :build
  depends_on "ninja" => :build

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
    (testpath/"test.c").write <<~EOS
      int         main(char *args) { \n   \t printf("hello"); }
    EOS

    assert_equal "int main(char *args) { printf(\"hello\"); }\n",
        shell_output("#{bin}/clang-format -style=Google test.c")
  end
end
