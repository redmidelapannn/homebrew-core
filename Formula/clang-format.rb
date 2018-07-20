class ClangFormat < Formula
  desc "Formatting tool for C/C++/Java/JavaScript/Objective-C/Protobuf"
  homepage "https://releases.llvm.org/6.0.1/tools/clang/docs/ClangFormat.html"
  version "6.0.1"

  stable do
    if MacOS.version >= :sierra
      url "https://llvm.org/svn/llvm-project/llvm/tags/RELEASE_601/final/", :using => :svn
    else
      url "http://llvm.org/svn/llvm-project/llvm/tags/RELEASE_601/final/", :using => :svn
    end

    resource "clang" do
      if MacOS.version >= :sierra
        url "https://llvm.org/svn/llvm-project/cfe/tags/RELEASE_601/final/", :using => :svn
      else
        url "http://llvm.org/svn/llvm-project/cfe/tags/RELEASE_601/final/", :using => :svn
      end
    end
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "facb1af05398a8f22232f835b205f97cf15e87ec95a09975479dc6539720ae9a" => :high_sierra
    sha256 "cd0cabec29c2e5ed0fd68a020d35294bd27f0d65fd5b0f8ae99231793947ea3b" => :sierra
    sha256 "8c52d2cde455cfc325cffbe69b47b1b8ae67d7cd5b60ac4d6d47fa52b3515b1e" => :el_capitan
  end

  head do
    if MacOS.version >= :sierra
      url "https://llvm.org/svn/llvm-project/llvm/trunk/", :using => :svn
    else
      url "http://llvm.org/svn/llvm-project/llvm/trunk/", :using => :svn
    end

    resource "clang" do
      if MacOS.version >= :sierra
        url "https://llvm.org/svn/llvm-project/cfe/trunk/", :using => :svn
      else
        url "http://llvm.org/svn/llvm-project/cfe/trunk/", :using => :svn
      end
    end
  end

  depends_on "cmake" => :build
  depends_on "ninja" => :build
  depends_on "subversion" => :build

  resource "libcxx" do
    url "https://releases.llvm.org/5.0.0/libcxx-5.0.0.src.tar.xz"
    sha256 "eae5981e9a21ef0decfcac80a1af584ddb064a32805f95a57c7c83a5eb28c9b1"
  end

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
