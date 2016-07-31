class ProtobufSwift < Formula
  desc "Implementation of Protocol Buffers in Apple Swift."
  homepage "https://github.com/alexeyxo/protobuf-swift"
  url "https://github.com/alexeyxo/protobuf-swift/archive/3.0.0.tar.gz"
  sha256 "3e93f410844049673a164698589f1cb2c8f8ee1e4169b6cee3c6c32f8f5c4edb"
  revision 1

  bottle do
    cellar :any
    sha256 "9784503d21b0b9f9a867b6ff4f073bc892a5ebec63d992e4ddcb9bed453c32cd" => :el_capitan
    sha256 "0f6fd6fb20abb7bf62c851d128062200fc5332dc9dcf72ae6091cb65d38e3202" => :yosemite
    sha256 "9f6cdb31392cab7dc52d7665c3c5aceb1d27181b5e280f100f9fe80cb7f4e5dd" => :mavericks
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
