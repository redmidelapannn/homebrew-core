class Libfishsound < Formula
  desc "Decode and encode audio data using the Xiph.org codecs"
  homepage "https://xiph.org/fishsound/"
  url "https://downloads.xiph.org/releases/libfishsound/libfishsound-1.0.0.tar.gz"
  sha256 "2e0b57ce2fecc9375eef72938ed08ac8c8f6c5238e1cae24458f0b0e8dade7c7"

  bottle do
    cellar :any
    rebuild 2
    sha256 "be4fedee46ddfe18138a78dae5c589ffbf7995be93f201a79b5c64f7d910c5a8" => :mojave
    sha256 "cb63dc5d1560c273554fe5e04d32bbf9757341c82d8eecb5c7aa35586000207c" => :high_sierra
    sha256 "48bf1b9af61f9fa190f23a38c36de2cd343a7d484c872db6a97e53c7b8c8ed49" => :sierra
    sha256 "078a2f8bf56bdf35b4e2b1bd68f3e9feaf0166cdef63355f4e546e2a5757b20e" => :el_capitan
  end

  depends_on "pkg-config" => :build
  depends_on "libvorbis"

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end
end
