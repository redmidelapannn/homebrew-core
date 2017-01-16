class Ldc < Formula
  desc "Portable D programming language compiler"
  homepage "https://wiki.dlang.org/LDC"

  stable do
    # for the sake of LLVM 3.9 compatibility
    url "https://github.com/ldc-developers/ldc.git",
        :branch => "release-1.0.1",
        :revision => "3461e00f3531f855f9fc6e92515d7affb8201827"
    version "1.0.1-alpha1"

    resource "ldc-lts" do
      url "https://github.com/ldc-developers/ldc/releases/download/v0.17.2/ldc-0.17.2-src.tar.gz"
      sha256 "8498f0de1376d7830f3cf96472b874609363a00d6098d588aac5f6eae6365758"
    end
  end

  bottle do
    rebuild 1
    sha256 "4976ae575849ec36c397314f8a304e9294343d02c48497c3d46cb34b661d78cf" => :sierra
    sha256 "c12d3bd6f3abffe9337b13c1409ca8b6c9f98f98b8806b9632fdbacf776de223" => :el_capitan
    sha256 "4b10dc5e5316a611e1f5ae57e7290b805cef5cdbd144a416a2b6c68473ee80ff" => :yosemite
  end

  devel do
    url "https://github.com/ldc-developers/ldc/releases/download/v1.1.0-beta6/ldc-1.1.0-beta6-src.tar.gz"
    sha256 "2ded84ba496d1fb02571745bb3679dce06664009bcd200c8d352b746c9399262"
    version "1.1.0-beta6"

    resource "ldc-lts" do
      url "https://github.com/ldc-developers/ldc/releases/download/v0.17.2/ldc-0.17.2-src.tar.gz"
      sha256 "8498f0de1376d7830f3cf96472b874609363a00d6098d588aac5f6eae6365758"
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

    if build.stable?
      system bin/"ldc2", "test.d"
    else
      system bin/"ldc2", "-flto=full", "test.d"
    end
    assert_match "Hello, world!", shell_output("./test")
    system bin/"ldmd2", "test.d"
    assert_match "Hello, world!", shell_output("./test")
  end
end
