class ClangFormat < Formula
  desc "Formatting tools for C, C++, Obj-C, Java, JavaScript, TypeScript"
  homepage "https://clang.llvm.org/docs/ClangFormat.html"
  version "2019-12-20"

  stable do
    url "https://github.com/llvm/llvm-project.git",
        :tag      => "llvmorg-9.0.1",
        :revision => "c1a0a213378a458fbea1a5c77b315c7dce08fd05"
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "e42ca08f57e025a3566d350a355dc978ff871ebb715e8b97c237711fa068b73d" => :catalina
    sha256 "135dacfbd09b331c962b4c4a23f87b96b860f4e18ffbcb08bc475ebd74f89eeb" => :mojave
    sha256 "36b913a35fd6afec124aa6bb925aed331275c0bebf1bf6d5d966863a10e6799c" => :high_sierra
  end

  head do
    url "https://github.com/llvm/llvm-project.git"
  end

  depends_on "cmake" => :build
  depends_on "ninja" => :build

  uses_from_macos "libxml2"
  uses_from_macos "ncurses"
  uses_from_macos "zlib"

  def install
    mkdir "build" do
      args = std_cmake_args
      args << "-DCMAKE_OSX_SYSROOT=/" unless MacOS::Xcode.installed?
      args << "-DLLVM_ENABLE_PROJECTS='clang;libcxx;clang-tools-extra'"
      args << "../llvm/"
      system "cmake", "-G", "Ninja", *args
      system "ninja", "clang-format"
      bin.install "bin/clang-format"
    end
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
