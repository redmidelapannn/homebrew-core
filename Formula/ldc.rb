class Ldc < Formula
  desc "Portable D programming language compiler"
  homepage "https://wiki.dlang.org/LDC"
  revision 2

  stable do
    url "https://github.com/ldc-developers/ldc/releases/download/v1.8.0/ldc-1.8.0-src.tar.gz"
    sha256 "e421a1f4bbf97d173bd277125794862ca5b6a09409586b806cec23b922955c7f"

    resource "ldc-lts" do
      url "https://github.com/ldc-developers/ldc/releases/download/v0.17.5/ldc-0.17.5-src.tar.gz"
      sha256 "7aa540a135f9fa1ee9722cad73100a8f3600a07f9a11d199d8be68887cc90008"
    end
  end

  bottle do
    rebuild 1
    sha256 "181a0509b23cb4bea5bd78319f91305b16d3c633611bc8b932831a9f75d326a3" => :high_sierra
    sha256 "b4b444a478b5f544492c2e33b53674fc8a0b2a6b2c04efde13728e86515f477f" => :sierra
    sha256 "ea49fa670d423b3779f9788a6c04dfdd530a28f3fa62ef23f6022dce3f0b598d" => :el_capitan
  end

  devel do
    url "https://github.com/ldc-developers/ldc/releases/download/v1.9.0-beta1/ldc-1.9.0-beta1-src.tar.gz"
    sha256 "208fb4ab7484872d3f52dc0d206303003ba604226706507176d92f45b6c1b348"

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
  depends_on "llvm@5"

  def install
    ENV.cxx11
    (buildpath/"ldc-lts").install resource("ldc-lts")

    cd "ldc-lts" do
      mkdir "build" do
        args = std_cmake_args + %W[
          -DLLVM_ROOT_DIR=#{Formula["llvm@5"].opt_prefix}
        ]
        system "cmake", "..", *args
        system "make"
      end
    end
    mkdir "build" do
      args = std_cmake_args + %W[
        -DLLVM_ROOT_DIR=#{Formula["llvm@5"].opt_prefix}
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
