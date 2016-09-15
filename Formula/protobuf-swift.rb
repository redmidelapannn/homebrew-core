class ProtobufSwift < Formula
  desc "Implementation of Protocol Buffers in Apple Swift."
  homepage "https://github.com/alexeyxo/protobuf-swift"
  url "https://github.com/alexeyxo/protobuf-swift/archive/3.0.1.tar.gz"
  sha256 "6345c1057d990a144400f6ae0849e04bb086f6b4b40cecd2166f15cc12a17e59"

  bottle do
    cellar :any
    sha256 "ec9a8e04550c65d94b6dd5f75cf6e7877f8baa13d4ba3c9513f2353d0b4d98e4" => :el_capitan
    sha256 "8b1c3b0e3e0aaf9a3d3680c515382382aa1026920d2a9f9bb7b37a59b0b14608" => :yosemite
    sha256 "077986d74f3cfa5fd741f7856d2f16bbd15f33517ff6e0eb6ba7ea2d822870d6" => :mavericks
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "protobuf"

  def install
    system "./autogen.sh"
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    testdata = <<-EOS.undent
      syntax = "proto3";
      enum Flavor {
        CHOCOLATE = 0;
        VANILLA = 1;
      }
      message IceCreamCone {
        int32 scoops = 1;
        Flavor flavor = 2;
      }
    EOS
    (testpath/"test.proto").write(testdata)
    system "protoc", "test.proto", "--swift_out=."
  end
end
