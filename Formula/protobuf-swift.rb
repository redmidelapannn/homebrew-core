class ProtobufSwift < Formula
  desc "Implementation of Protocol Buffers in Swift"
  homepage "https://github.com/alexeyxo/protobuf-swift"
  url "https://github.com/alexeyxo/protobuf-swift/archive/3.0.20.tar.gz"
  sha256 "040154ea135dfc80c1f5e478e3c5af81cbe825f991280a014413d5a14f619d5b"

  bottle do
    cellar :any
    sha256 "52e566fad0f4ab045a3476f1a8a6ac87eb0b70ba16b82cab7b6e68d111afe05b" => :sierra
    sha256 "c7cb23b28175f6507a49b68b6ea1ab4f310593a1b1e1bc88ec62651f786bca29" => :el_capitan
    sha256 "9ce370c8a03f9d2ea741e03fd5757ad2ae4f4a1f944d7e8e6b1f1e486e89c41e" => :yosemite
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "protobuf"

  def install
    system "protoc", "-Iplugin/compiler",
                     "plugin/compiler/google/protobuf/descriptor.proto",
                     "plugin/compiler/google/protobuf/swift-descriptor.proto",
                     "--cpp_out=plugin/compiler"
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
