class T1lib < Formula
  desc "C library to generate/rasterize bitmaps from Type 1 fonts"
  homepage "https://www.t1lib.org/"
  url "https://www.ibiblio.org/pub/linux/libs/graphics/t1lib-5.1.2.tar.gz"
  mirror "https://fossies.org/linux/misc/old/t1lib-5.1.2.tar.gz"
  sha256 "821328b5054f7890a0d0cd2f52825270705df3641dbd476d58d17e56ed957b59"

  bottle do
    rebuild 3
    sha256 "723b2861c99395b94eae479a55ba81e2b313798bf2d05c358f8efe86c0b4877e" => :high_sierra
    sha256 "b25d169f4f883d99c02cc9ecf796b57611fb0f53f5df061cc20a2547c4b124a0" => :sierra
    sha256 "89e6bf82254a0b29d623f9ed87008ab8f2ce194385d61e8482b9e06a1a2a481b" => :el_capitan
  end

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make", "without_doc"
    system "make", "install"
    share.install "Fonts" => "fonts"
  end
end
