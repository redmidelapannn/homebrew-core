class Ldc < Formula
  desc "Portable D programming language compiler"
  homepage "https://wiki.dlang.org/LDC"
  url "https://github.com/ldc-developers/ldc/releases/download/v0.17.1/ldc-0.17.1-src.tar.gz"
  sha256 "8f5453e4e0878110ab03190ae9313ebbb323884090e6e7db87b02e5ed6a1c8b0"

  bottle do
    revision 1
    sha256 "d75871405ab24b51973a5a0c1f768a80aa4264129b8a725c82e971c74ff8572b" => :el_capitan
    sha256 "e752ea28e455aa9076d98cc4ee5a04e5dd790b06588a7524458efa011024206a" => :yosemite
    sha256 "f3549d99bc51e64747f8e98c9938a3a57a5d545e4455e1de2f146549ff167cd7" => :mavericks
  end

  devel do
    url "https://github.com/ldc-developers/ldc/releases/download/v1.0.0-beta2/ldc-1.0.0-beta2-src.tar.gz"
    sha256 "0aa58dd3aba41623218af7bbdaaa3f5dc941c0b157ec612592aac0d52660f71e"
    version "1.0.0-beta2"

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
  depends_on "llvm" => :build
  depends_on "libconfig"

  def install
    ENV.cxx11
    if build.stable?
      mkdir "build" do
        system "cmake", "..", "-DINCLUDE_INSTALL_DIR=#{include}/dlang/ldc", *std_cmake_args
        system "make"
        system "make", "install"
      end
    else
      (buildpath/"ldc-lts").install resource("ldc-lts")
      cd "ldc-lts" do
        mkdir "build" do
          system "cmake", "..", *std_cmake_args
          system "make"
        end
      end
      mkdir "build" do
        system "cmake", "..", "-DINCLUDE_INSTALL_DIR=#{include}/dlang/ldc", "-DD_COMPILER=#{buildpath}/ldc-lts/build/bin/ldmd2", *std_cmake_args
        system "make"
        system "make", "install"
      end
    end
  end

  test do
    (testpath/"test.d").write <<-EOS.undent
      import std.stdio;
      void main() {
        writeln("Hello, world!");
      }
    EOS

    system "#{bin}/ldc2", "test.d"
    system "./test"
    system "#{bin}/ldmd2", "test.d"
    system "./test"
  end
end
