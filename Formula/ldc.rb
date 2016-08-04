class Ldc < Formula
  desc "Portable D programming language compiler"
  homepage "https://wiki.dlang.org/LDC"
  revision 1

  stable do
    url "https://github.com/ldc-developers/ldc/releases/download/v1.0.0/ldc-1.0.0-src.tar.gz"
    sha256 "3740ee6d5871e953aeb03b11f9d8c951286a55884892b51981bfe579b8fe571d"

    resource "ldc-lts" do
      url "https://github.com/ldc-developers/ldc/releases/download/v0.17.1/ldc-0.17.1-src.tar.gz"
      sha256 "8f5453e4e0878110ab03190ae9313ebbb323884090e6e7db87b02e5ed6a1c8b0"
    end
  end

  bottle do
    revision 1
    sha256 "b655bcf69823198987cad0d5e68c66c696bbf0517305a17ad595f0565cfedf6e" => :el_capitan
    sha256 "45b9a4f0bbfb1f1d892332ccb892fed6e2989ad3727b4180806f2f6700c8b33c" => :yosemite
    sha256 "47d3ab3847dd11bd4041efa9a8d418556ad4e78109605fb6ef5c7ff8d9417735" => :mavericks
  end

  devel do
    url "https://github.com/ldc-developers/ldc/releases/download/v1.1.0-beta2/ldc-1.1.0-beta2-src.tar.gz"
    sha256 "36d7094c642bbfab331e1db5fbaeeb967d1e8d09f25aeaf8262fa88eb8358ca5"
    version "1.1.0-beta2"

    resource "ldc-lts" do
      url "https://github.com/ldc-developers/ldc/releases/download/v0.17.1/ldc-0.17.1-src.tar.gz"
      sha256 "8f5453e4e0878110ab03190ae9313ebbb323884090e6e7db87b02e5ed6a1c8b0"
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

    system bin/"ldc2", "test.d"
    assert_match "Hello, world!", shell_output("./test")
    system bin/"ldmd2", "test.d"
    assert_match "Hello, world!", shell_output("./test")
  end
end
