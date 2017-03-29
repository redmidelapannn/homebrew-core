class Tre < Formula
  desc "Lightweight, POSIX-compliant regular expression (regex) library"
  homepage "https://laurikari.net/tre/"
  url "https://laurikari.net/tre/tre-0.8.0.tar.bz2"
  sha256 "8dc642c2cde02b2dac6802cdbe2cda201daf79c4ebcbb3ea133915edf1636658"

  bottle do
    cellar :any
    rebuild 1
    sha256 "8d7e9dcdd6d54b9df313a5548c677644843ab5b704d55e8ba281fecbf3a832bc" => :sierra
    sha256 "6c7cd8f6bb5eca63c71475db5415ae6b854ee4047dd9cf05be965cb785e528c9" => :el_capitan
    sha256 "c966aec1f2fa1f019c69d673c1d6226b0a0d78ef9e58056d83d45b6d50e667e0" => :yosemite
  end

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    assert_equal "brow", pipe_output("#{bin}/agrep -1 brew", "brow", 0)
  end
end
