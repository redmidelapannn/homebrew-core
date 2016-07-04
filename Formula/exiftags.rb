class Exiftags < Formula
  desc "Utility to read EXIF tags from a digital camera JPEG file"
  homepage "https://johnst.org/sw/exiftags/"
  url "https://johnst.org/sw/exiftags/exiftags-1.01.tar.gz"
  sha256 "d95744de5f609f1562045f1c2aae610e8f694a4c9042897a51a22f0f0d7591a4"

  bottle do
    cellar :any_skip_relocation
    revision 1
    sha256 "47d75e83f89d0db4a54d779d9c9820fbb788c102738824e86b83a441d9a60af8" => :el_capitan
    sha256 "d649152d599c830339261d99c23c33a19596bd6052319c2d84e13cf876513da5" => :yosemite
    sha256 "b51f760169ea5603e49acee514d6ef42cde8a45c2da24d67a2e0eba931645bf2" => :mavericks
  end

  def install
    bin.mkpath
    man1.mkpath
    system "make", "prefix=#{prefix}", "mandir=#{man}", "install"
  end

  test do
    system "#{bin}/exiftags", test_fixtures("test.jpg")
  end
end
