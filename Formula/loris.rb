class Loris < Formula
  desc "Audio analysis, manipulation and synthesis"
  homepage "http://www.cerlsoundgroup.org/Loris"
  url "https://github.com/MatthiasWinkelmann/loris/archive/1.9.tar.gz"
  sha256 "94b894c05b31a59d08fe23b8403e1df3dc8b876acffe21d38a393a27775da2ac"

  bottle do
    cellar :any
    sha256 "a02addb8c39b64c2f2a68792ebce82b070bd897502a5b0f339eac44a6de4c11c" => :sierra
    sha256 "7247bd44b4a23319465c480d3e3d66c683713f439c6efc6e7b395c869819c8eb" => :el_capitan
    sha256 "802d35cf30ed2423b8eac4ab97be6d838fb0d51b20e5dc887b90179ba2ffbd0a" => :yosemite
  end

  depends_on "fftw"
  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build

  def install
    system "./reconf"
    system "./configure", "--prefix=#{prefix}", "--with-python=no"
    system "make", "install"
  end

  test do
    system "echo 'testing testing 1 2 3' | #{bin}/loris-analyze 50 -o /dev/null -verbose"
  end
end
