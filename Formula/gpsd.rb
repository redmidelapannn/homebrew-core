class Gpsd < Formula
  desc "Global Positioning System (GPS) daemon"
  homepage "http://catb.org/gpsd/"
  url "https://download.savannah.gnu.org/releases/gpsd/gpsd-3.16.tar.gz"
  sha256 "03579af13a4d3fe0c5b79fa44b5f75c9f3cac6749357f1d99ce5d38c09bc2029"

  bottle do
    cellar :any
    rebuild 1
    sha256 "70f305a3f265e488a69deef8a32fd2525dfd7eba331b80565191b512b8eaace4" => :sierra
    sha256 "7970a89c319410fa069e11352e5b44d9f5ca183a8b2f17230a5e369520461419" => :el_capitan
  end

  depends_on "scons" => :build
  depends_on "libusb" => :optional

  def install
    system "2to3", "--write", "--fix=print", "SConstruct"
    scons "chrpath=False", "python=False", "strip=False", "prefix=#{prefix}/"
    scons "install"
  end
end
