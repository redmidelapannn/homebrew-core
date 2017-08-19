class Libfastjson < Formula
  desc "A fast json library for C"
  homepage "https://github.com/rsyslog/libfastjson"
  url "https://github.com/rsyslog/libfastjson/archive/v0.99.6.tar.gz"
  version "0.99.6"
  sha256 "617373e5205c84b5f674354df6ee9cba53ef8a227f0d1aa928666ed8a16d5547"
  depends_on "libtool" => :build
  depends_on "automake" => :build
  depends_on "autoconf" => :build

  bottle do
    cellar :any
    sha256 "4eb6f15066dab2afb374eddbec9cc4e659dbdaa17b24f7ff522587c20d52a6e3" => :sierra
  end

  head do
    url "https://github.com/rsyslog/libfastjson.git"
  end

  def install
    system "./autogen.sh"
    system "./configure", "--prefix=#{prefix}"
    ENV.deparallelize
    system "make", "install"
  end
end
