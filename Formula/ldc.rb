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
  end

  bottle do
    rebuild 1
    sha256 "a15bf91440937da90a5fdc6047fc752e6cab2331367566989f2b5c7156c35913" => :sierra
    sha256 "68b2a1e6da7091a0df07cdb8d6405183d091ecaf9e2cbb0422b43242100dd88c" => :el_capitan
    sha256 "6655743a11b7b0f8bfc3139011356f7ef1ca95835fe40fbcc879df9d82f662f8" => :yosemite
  end

  devel do
    url "https://github.com/ldc-developers/ldc/releases/download/v1.3.0-beta1/ldc-1.3.0-beta1-src.tar.gz"
    sha256 "35d5c37e967ccfa762572d0c5cb73e42617615d5eb16e43595a4bf239dd14e49"
    version "1.3.0-beta1"

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
  depends_on "libconfig"

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
