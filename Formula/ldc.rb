class Ldc < Formula
  desc "Portable D programming language compiler"
  homepage "https://wiki.dlang.org/LDC"

  stable do
    url "https://github.com/ldc-developers/ldc/releases/download/v1.5.0/ldc-1.5.0-src.tar.gz"
    sha256 "03659a4b9cafff0cf8d537469dd15579f097c7748a342ea2a5770fa0edd3a084"

    resource "ldc-lts" do
      url "https://github.com/ldc-developers/ldc/releases/download/v0.17.5/ldc-0.17.5-src.tar.gz"
      sha256 "7aa540a135f9fa1ee9722cad73100a8f3600a07f9a11d199d8be68887cc90008"
    end
  end

  bottle do
    rebuild 1
    sha256 "0d10e97fda38238f7910b753b5aa44f319c78a23da3a8d0c9259957aebd44ee7" => :high_sierra
    sha256 "57026af0319b487c8e892833b654834f5091df5cd598a23068f28d9ce5fcf979" => :sierra
    sha256 "1d38d4dcfb32e2ccf971bab12755064402cd2c833315282b623ffee2755dd633" => :el_capitan
  end

  devel do
    url "https://github.com/ldc-developers/ldc/releases/download/v1.6.0-beta1/ldc-1.6.0-beta1-src.tar.gz"
    sha256 "4216b32b7fdcc65a410a7c0724af6cd4f3ae02b14749b3c073f1e55de8fd6028"

    resource "ldc-lts" do
      url "https://github.com/ldc-developers/ldc/releases/download/v0.17.5/ldc-0.17.5-src.tar.gz"
      sha256 "7aa540a135f9fa1ee9722cad73100a8f3600a07f9a11d199d8be68887cc90008"
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
  depends_on "libconfig" => :build
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
        -DLDC_WITH_LLD=OFF
        -DRT_ARCHIVE_WITH_LDC=OFF
      ]
      # LDC_WITH_LLD see https://github.com/ldc-developers/ldc/releases/tag/v1.4.0 Known issues
      # RT_ARCHIVE_WITH_LDC see https://github.com/ldc-developers/ldc/issues/2350

      system "cmake", "..", *args
      system "make"
      system "make", "install"
    end
  end

  test do
    (testpath/"test.d").write <<~EOS
      import std.stdio;
      void main() {
        writeln("Hello, world!");
      }
    EOS
    system bin/"ldc2", "test.d"
    assert_match "Hello, world!", shell_output("./test")
    system bin/"ldc2", "-flto=thin", "test.d"
    assert_match "Hello, world!", shell_output("./test")
    system bin/"ldc2", "-flto=full", "test.d"
    assert_match "Hello, world!", shell_output("./test")
    system bin/"ldmd2", "test.d"
    assert_match "Hello, world!", shell_output("./test")
  end
end
