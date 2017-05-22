class ClangTidy < Formula
  desc "clang-based C++ “linter” tool."
  homepage "https://clang.llvm.org/extra/clang-tidy/"
  url "http://releases.llvm.org/4.0.0/llvm-4.0.0.src.tar.xz"
  sha256 "8d10511df96e73b8ff9e7abbfb4d4d432edbdbe965f1f4f07afaf370b8a533be"

  bottle do
    cellar :any_skip_relocation
    sha256 "92db127d717d60cb2b1c6a520e94500e0f595723442de0dc26f6ea8fe8f75853" => :sierra
    sha256 "6c9071a03b1002602df55958dea427adb1c8a66048834c758d8bf5a00c9436aa" => :el_capitan
    sha256 "2c45abaf0ad949a2fcdc956cad61c51eea61f77a88405f9df3689903454c864a" => :yosemite
  end

  depends_on "cmake" => :build
  depends_on "ninja" => :build

  resource "clang" do
    url "http://releases.llvm.org/4.0.0/cfe-4.0.0.src.tar.xz"
    sha256 "cea5f88ebddb30e296ca89130c83b9d46c2d833685e2912303c828054c4dc98a"
  end

  resource "extra" do
    url "http://releases.llvm.org/4.0.0/clang-tools-extra-4.0.0.src.tar.xz"
    sha256 "41b7d37eb128fd362ab3431be5244cf50325bb3bb153895735c5bacede647c99"
  end

  def install
    (buildpath/"tools/clang").install resource("clang")
    (buildpath/"tools/clang/tools/extra").install resource("extra")

    mkdir "build" do
      args = std_cmake_args
      args << ".."
      system "cmake", "-G", "Ninja", *args
      system "ninja", "clang-tidy"
      bin.install "bin/clang-tidy"
    end
  end

  test do
    (testpath/"test.cpp").write <<-EOS
      int main() { printf(\"hello\"); }
    EOS

    assert shell_output(
      "#{bin}/clang-tidy test.cpp --",
    ).include? "undeclared identifier 'printf'"
  end
end
