class Ldc < Formula
  desc "Portable D programming language compiler"
  homepage "https://wiki.dlang.org/LDC"

  stable do
    url "https://github.com/ldc-developers/ldc/releases/download/v1.2.0/ldc-1.2.0-src.tar.gz"
    sha256 "910e8a670f0fadcaf64403c924091d6debf7ad29e203808f5f2b6899217e6f2b"

    resource "ldc-lts" do
      url "https://github.com/ldc-developers/ldc/releases/download/v0.17.4/ldc-0.17.4-src.tar.gz"
      sha256 "48428afde380415640f3db4e38529345f3c8485b1913717995547f907534c1c3"
    end

    depends_on "libconfig"
  end

  bottle do
    rebuild 1
    sha256 "40258687358858b9e74002c1f7b25f739f4b73d66520ecae4673b2f68571bd92" => :sierra
    sha256 "0b4df32893aca873f5a7bc98c97c5c619a75971ac98b0e116e2d60866b5a39df" => :el_capitan
    sha256 "68bd3a019304c992af7fe07fb6a3af846cab3381abd1219f56f656a659af442e" => :yosemite
  end

  devel do
    url "https://github.com/ldc-developers/ldc/releases/download/v1.3.0-beta1/ldc-1.3.0-beta1-src.tar.gz"
    version "1.3.0-beta1"
    sha256 "35d5c37e967ccfa762572d0c5cb73e42617615d5eb16e43595a4bf239dd14e49"

    resource "ldc-lts" do
      url "https://github.com/ldc-developers/ldc/releases/download/v0.17.4/ldc-0.17.4-src.tar.gz"
      sha256 "48428afde380415640f3db4e38529345f3c8485b1913717995547f907534c1c3"
    end
  end

  head do
    url "https://github.com/ldc-developers/ldc.git", :shallow => false

    resource "ldc-lts" do
      url "https://github.com/ldc-developers/ldc.git", :shallow => false, :branch => "ltsmaster"
    end
  end

  needs :cxx11

  depends_on "cmake" => :build
  depends_on "llvm"

  def install
    ENV.cxx11
    (buildpath/"ldc-lts").install resource("ldc-lts")

    cd "ldc-lts" do
      mkdir "build" do
        args = std_cmake_args + %W[
          -DLLVM_ROOT_DIR=#{Formula["llvm"].opt_prefix}
        ]
        system "cmake", "..", *args
        system "make"
      end
    end
    mkdir "build" do
      args = std_cmake_args + %W[
        -DLLVM_ROOT_DIR=#{Formula["llvm"].opt_prefix}
        -DINCLUDE_INSTALL_DIR=#{include}/dlang/ldc
        -DD_COMPILER=#{buildpath}/ldc-lts/build/bin/ldmd2
      ]

      system "cmake", "..", *args
      system "make"
      system "make", "install"
    end
  end

  test do
    (testpath/"test.d").write <<-EOS.undent
      import std.stdio;
      void main() {
        writeln("Hello, world!");
      }
    EOS

    system bin/"ldc2", "-flto=full", "test.d"

    assert_match "Hello, world!", shell_output("./test")
    system bin/"ldmd2", "test.d"
    assert_match "Hello, world!", shell_output("./test")
  end
end
