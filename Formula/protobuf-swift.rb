class ProtobufSwift < Formula
  desc "Implementation of Protocol Buffers in Swift"
  homepage "https://github.com/alexeyxo/protobuf-swift"
  url "https://github.com/alexeyxo/protobuf-swift/archive/3.0.24.tar.gz"
  sha256 "b259dbf0306c3cb37fa15958cc1b3135ca2fd4febee2362f2917f19acdc093e8"

  bottle do
    cellar :any
    rebuild 1
    sha256 "27ecfc833c71f7efc1729bd43f10a60bdc09927188d0558e195820d751455c69" => :high_sierra
    sha256 "a134fb0482da3589631f43a6dccb7bae7b8ebcc2df366c6a0b559ef6072ffa11" => :sierra
    sha256 "fe3399093c993d7105fbc283dc2c4732a4f91a4b3c6d693e8ae26da4c837ef6a" => :el_capitan
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "protobuf"

  conflicts_with "swift-protobuf",
    :because => "both install `protoc-gen-swift` binaries"

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
    testdata = <<~EOS
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
    system Formula["protobuf"].opt_bin/"protoc", "test.proto", "--swift_out=."
  end
end
