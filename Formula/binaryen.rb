class Binaryen < Formula
  desc "Compiler infrastructure and toolchain library for WebAssembly"
  homepage "https://webassembly.org/"
  url "https://github.com/WebAssembly/binaryen/archive/version_91.tar.gz"
  sha256 "522a30c0fd29f55d44dbc299aa768eccbda67ef134c8563085f874daa5622d7a"
  revision 1
  head "https://github.com/WebAssembly/binaryen.git"

  bottle do
    cellar :any
    sha256 "f939f4bd2a3ec1651fc90d2d84eb4b300c301c3acee4fb42c63de137b46e4407" => :catalina
    sha256 "e07c99cedf64a8267707388436b461dbb2a0a60cf5d05ec9f45b343da576b591" => :mojave
    sha256 "6ac92995dbaddff28ca588725f0f89f5212a0989dc0e21457338a7bfe22f8e33" => :high_sierra
  end

  depends_on "cmake" => :build
  depends_on "python@3.8" => :build
  depends_on :macos => :el_capitan # needs thread-local storage

  def install
    ENV.cxx11

    system "cmake", ".", *std_cmake_args
    system "make", "install"

    pkgshare.install "test/"
  end

  test do
    system "#{bin}/wasm-opt", "#{pkgshare}/test/passes/O.wast"
    system "#{bin}/asm2wasm", "#{pkgshare}/test/hello_world.asm.js"
  end
end
