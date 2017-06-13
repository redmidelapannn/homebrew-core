class T1lib < Formula
  desc "C library to generate/rasterize bitmaps from Type 1 fonts"
  homepage "https://www.t1lib.org/"
  url "https://www.ibiblio.org/pub/linux/libs/graphics/t1lib-5.1.2.tar.gz"
  mirror "ftp://ftp.ibiblio.org/pub/linux/libs/graphics/t1lib-5.1.2.tar.gz"
  sha256 "821328b5054f7890a0d0cd2f52825270705df3641dbd476d58d17e56ed957b59"

  bottle do
    rebuild 3
    sha256 "83154fafbc8cf0d0ad5a72163d5b5549b86c62bf44d86ff90eca3f438d9248dc" => :sierra
    sha256 "0083b71bc5105bc1ec76a852461c407bbdff3489e4934574876ff22c6983b3ba" => :el_capitan
    sha256 "aaa7e40719ba1f9f27c56f49daf5b3c6776d33afc88fd58f782c6dcf289acf52" => :yosemite
  end

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make", "without_doc"
    system "make", "install"
    share.install "Fonts" => "fonts"
  end
end
