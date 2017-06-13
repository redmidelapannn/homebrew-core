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
    sha256 "4181b22b198885a35cbdb9476d0e4f08c6842028633245b4dd48dee1e5f9b878" => :sierra
    sha256 "216be1f9f23e2b319054c81d5407d1787f7064fbac4040f69d492bc10ce77fc7" => :el_capitan
    sha256 "1003aa2cdb541bd6ac1fcac49988ce41e1bf6240a1ea1bda64a8a2409094dd8c" => :yosemite
  end

  devel do
    url "https://github.com/ldc-developers/ldc/releases/download/v1.3.0-beta2/ldc-1.3.0-beta2-src.tar.gz"
    version "1.3.0-beta2"
    sha256 "a6a13f356192d40649af7290820cf85127369f40d554c2fdd853dc098dce885f"

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
