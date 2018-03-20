class Moe < Formula
  desc "Console text editor for ISO-8859 and ASCII"
  homepage "https://www.gnu.org/software/moe/moe.html"
  url "https://ftp.gnu.org/gnu/moe/moe-1.9.tar.lz"
  mirror "https://ftpmirror.gnu.org/moe/moe-1.9.tar.lz"
  sha256 "18919e9ffae08f34d8beb3a26fc5a595614e0aff34866e79420ca81881ff4ef3"

  bottle do
    rebuild 2
    sha256 "06f88b528bf266d3f5b4f314b8ee804ea0cff455bae567d6153df79b642f0d26" => :high_sierra
    sha256 "a115d0747c946ae497478df8f8a8ab3d8ebffe494d89209dd9c5202b0720fb07" => :sierra
    sha256 "bccb22acf8e95ab3efdb95aaeb449cd7e82bb1982b20dfa46bfdd3764d39ec5e" => :el_capitan
  end

  def install
    # Fix compilation bug with Xcode 9
    # https://lists.gnu.org/archive/html/bug-moe/2017-10/msg00000.html
    inreplace "window_vector.cc", "{ year_string.insert( 0U, 1,",
                                  "{ year_string.insert( 0U, 1U,"

    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/moe", "--version"
  end
end
