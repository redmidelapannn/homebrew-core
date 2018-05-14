class Binaryen < Formula
  desc "Compiler infrastructure and toolchain library for WebAssembly"
  homepage "https://webassembly.org/"
  url "https://github.com/WebAssembly/binaryen/archive/version_47.tar.gz"
  sha256 "596804438bc2b1ed21c8158c8e61cc1781beb4aee7c61f3126df02647cff1f09"

  head "https://github.com/WebAssembly/binaryen.git"

  bottle do
    cellar :any
    rebuild 1
    sha256 "2d73f4f570bb46c022b3ae220992ae1498c86fbdcfe6e8e8da4034a62e877ff8" => :high_sierra
    sha256 "e185c35dfc49b01731d96aba57b2e52a537bf6295256b96ef8b67b9a9d459dcd" => :sierra
    sha256 "569e05b71750db8c30d44702dae999366999610138c2d7db6545bd31acce82a7" => :el_capitan
  end

  depends_on "cmake" => :build
  depends_on :macos => :el_capitan # needs thread-local storage

  needs :cxx11

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
