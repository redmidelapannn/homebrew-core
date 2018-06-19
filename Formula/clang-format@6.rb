class ClangFormatAT6 < Formula
  desc "Formatting tools for C, C++, Obj-C, Java, JavaScript, TypeScript"
  homepage "https://clang.llvm.org/docs/ClangFormat.html"
  url "https://releases.llvm.org/6.0.0/llvm-6.0.0.src.tar.xz"
  sha256 "1ff53c915b4e761ef400b803f07261ade637b0c269d99569f18040f3dcee4408"

  bottle do
    cellar :any_skip_relocation
    sha256 "3d43c40ca0288560e8569ef417cebfe368653af27d1e0e45b8d15115e6a06c67" => :high_sierra
    sha256 "5d7a0ac715a5ea3ccac3945a93ec615fe939479f36edd25306d639233349ac48" => :sierra
    sha256 "8971b8c13a2cefc1e01844e93b749ab341f16b4e6bdf88a30500cc5229f15035" => :el_capitan
  end

  keg_only :versioned_formula

  depends_on "cmake" => :build
  depends_on "ninja" => :build
  depends_on "subversion" => :build

  resource "clang" do
    url "https://releases.llvm.org/6.0.0/cfe-6.0.0.src.tar.xz"
    sha256 "e07d6dd8d9ef196cfc8e8bb131cbd6a2ed0b1caf1715f9d05b0f0eeaddb6df32"
  end

  resource "libcxx" do
    url "https://releases.llvm.org/6.0.0/libcxx-6.0.0.src.tar.xz"
    sha256 "70931a87bde9d358af6cb7869e7535ec6b015f7e6df64def6d2ecdd954040dd9"
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
    # the below C code is intentionally messily formatted.
    (testpath/"test.c").write <<~EOS
      int         main(char *args) { \n   \t printf("hello"); }
    EOS

    assert_equal "int main(char *args) { printf(\"hello\"); }\n",
        shell_output("#{bin}/clang-format -style=Google test.c")
  end
end
