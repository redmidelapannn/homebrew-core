class Libzip < Formula
  desc "C library for reading, creating, and modifying zip archives"
  homepage "https://www.nih.at/libzip/"
  url "https://www.nih.at/libzip/libzip-1.1.2.tar.xz"
  sha256 "a921b45b5d840e998ff2544197eba4c3593dccb8ad0ee938630c2227c2c59fb3"

  bottle do
    cellar :any
    rebuild 1
    sha256 "2d1cdc747a63b459cff21c5b4f7cc4e8969d5559fbe8b0c5efc4abdc8fa919e6" => :sierra
    sha256 "ecb64b867cb9b41287156becf9cf0550ff61bb435753921a9a64a0860697aaac" => :el_capitan
    sha256 "62aa7f3bf192485db507f941a9d2ab112c7ca394208768a901e0b8c47197f1d0" => :yosemite
  end

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--mandir=#{man}",
                          "CXX=#{ENV.cxx}",
                          "CXXFLAGS=#{ENV.cflags}"
    system "make", "install"
  end

  test do
    touch "file1"
    system "zip", "file1.zip", "file1"
    touch "file2"
    system "zip", "file2.zip", "file1", "file2"
    assert_match /\+.*file2/, shell_output("#{bin}/zipcmp -v file1.zip file2.zip", 1)
  end
end
