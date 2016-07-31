class ProtobufC < Formula
  desc "Protocol buffers library"
  homepage "https://github.com/protobuf-c/protobuf-c"
  url "https://github.com/protobuf-c/protobuf-c/releases/download/v1.2.1/protobuf-c-1.2.1.tar.gz"
  sha256 "846eb4846f19598affdc349d817a8c4c0c68fd940303e6934725c889f16f00bd"
  revision 1

  bottle do
    sha256 "5662fd7fd4b3428078739cba4ad7c8753abff9f0e09486739a0fec1fe91bf05b" => :el_capitan
    sha256 "fce20fb11c10f3059ab1e295437b53ad5be366565b08156600b070561cabb962" => :yosemite
    sha256 "603c12f05b1accddb72e39e453a68009a92873fca3fb6cfef18197e12f8d5267" => :mavericks
  end

  option :universal

  depends_on "pkg-config" => :build
  depends_on "protobuf"

  def install
    ENV.universal_binary if build.universal?

    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make", "install"
  end
end
