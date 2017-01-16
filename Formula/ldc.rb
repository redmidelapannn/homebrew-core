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
    sha256 "ccb4b3905546927c47cf69f870d852a65d8631094859f8c3849a621f7806378d" => :sierra
    sha256 "f0a0c3f4a154e20eab9c090777c2342bb4387c92932cc0e3ef1d062af235934d" => :el_capitan
    sha256 "727d5384fca4c82072979799e1cf10f51adf409ed3c3c9021ca196ed77633974" => :yosemite
  end

  devel do
    url "https://github.com/ldc-developers/ldc/releases/download/v1.1.0-beta3/ldc-1.1.0-beta3-src.tar.gz"
    sha256 "cf4aeb393eada610aa3bad18c3ae6a5de94250eaa968fe2d1b0a6afdf8ea54f6"
    version "1.1.0-beta3"

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

  option "with-shared-libs", "build shared libs"

  needs :cxx11

  depends_on "cmake" => :build
  depends_on "llvm"
  depends_on "libconfig"

  def install
    ENV.cxx11
    (buildpath/"ldc-lts").install resource("ldc-lts")
    is_shared = (build.with? "shared-libs") ? "ON" : "OFF"
    cd "ldc-lts" do
      mkdir "build" do
        args = std_cmake_args + %W[
          -DBUILD_SHARED_LIBS=#{is_shared}
          -DLLVM_ROOT_DIR=#{Formula["llvm"].opt_prefix}
        ]
        system "cmake", "..", *args
        system "make"
      end
    end
    mkdir "build" do
      args = std_cmake_args + %W[
        -DBUILD_SHARED_LIBS=#{is_shared}
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

    system bin/"ldc2", "test.d"
    assert_match "Hello, world!", shell_output("./test")
    system bin/"ldmd2", "test.d"
    assert_match "Hello, world!", shell_output("./test")
  end
end
