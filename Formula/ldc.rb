class Ldc < Formula
  desc "Portable D programming language compiler"
  homepage "https://wiki.dlang.org/LDC"
  url "https://github.com/ldc-developers/ldc/releases/download/v1.20.0/ldc-1.20.0-src.tar.gz"
  sha256 "49c9fdfe3a51c978385aae94f2e102f306102f6282215638f2ae3fb9ea8d3ab9"
  revision 0
  head "https://github.com/ldc-developers/ldc.git", :shallow => false

  bottle do
    sha256 "1c94995b522a57cb0e5c5e0d7ade720767d126fffe5f428080c1ab180c106bf0" => :catalina
    sha256 "8978d413a10749299628df7185f5d85c35618605ea19791873ee93ae4f35b151" => :mojave
  end

  depends_on "cmake" => :build
  depends_on "libconfig" => :build
  depends_on "llvm"

  resource "ldc-bootstrap" do
    url "https://github.com/ldc-developers/ldc/releases/download/v1.19.0/ldc2-1.19.0-osx-x86_64.tar.xz"
    version "1.19.0"
    sha256 "c7bf6facfa61f2e771091b834397b36331f5c28a56e988f06fc4dc9fe0ece3ae"
  end

  def install
    ENV.cxx11
    (buildpath/"ldc-bootstrap").install resource("ldc-bootstrap")

    mkdir "build" do
      args = std_cmake_args + %W[
        -DLLVM_ROOT_DIR=#{Formula["llvm"].opt_prefix}
        -DINCLUDE_INSTALL_DIR=#{include}/dlang/ldc
        -DD_COMPILER=#{buildpath}/ldc-bootstrap/bin/ldmd2
      ]

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
