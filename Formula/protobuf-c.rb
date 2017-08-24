class ProtobufC < Formula
  desc "Protocol buffers library"
  homepage "https://github.com/protobuf-c/protobuf-c"
  url "https://github.com/protobuf-c/protobuf-c/releases/download/v1.3.0/protobuf-c-1.3.0.tar.gz"
  sha256 "5dc9ad7a9b889cf7c8ff6bf72215f1874a90260f60ad4f88acf21bb15d2752a1"

  bottle do
    rebuild 1
    sha256 "979c8e9d361123eeaebc9b0cb299c0ca90795296a4018e9dd2e38bb8e73f41fb" => :sierra
    sha256 "532b2c41c9383b01e39b1134d487da5d1460d71be250eb21140cc72dfacf02c5" => :el_capitan
    sha256 "b025397e646946522b0e71d2fb9e3e8482660f2631282b922a2be2693027947b" => :yosemite
  end

  depends_on "pkg-config" => :build
  depends_on "protobuf"

  def install
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    testdata = <<-EOS.undent
      syntax = "proto3";
      package test;
      message TestCase {
        string name = 4;
      }
      message Test {
        repeated TestCase case = 1;
      }
    EOS
    (testpath/"test.proto").write testdata
    system Formula["protobuf"].opt_bin/"protoc", "test.proto", "--c_out=."
  end
end
