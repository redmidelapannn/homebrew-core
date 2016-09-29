class Exiftags < Formula
  desc "Utility to read EXIF tags from a digital camera JPEG file"
  homepage "https://johnst.org/sw/exiftags/"
  url "https://johnst.org/sw/exiftags/exiftags-1.01.tar.gz"
  sha256 "d95744de5f609f1562045f1c2aae610e8f694a4c9042897a51a22f0f0d7591a4"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "7aaa2a8e78b03e4f842c84a46ce7fb5ed8ff1a956ababde1f26bc716431a67e0" => :sierra
    sha256 "3081e4676910d05777eec9d32855ad90f55d4c862412c024f6146e2e369c2313" => :el_capitan
    sha256 "76ba785ace6c89aafd2b82dadd6a862610914e51a412b4b7db92346210ba2072" => :yosemite
  end

  def install
    bin.mkpath
    man1.mkpath
    system "make", "prefix=#{prefix}", "mandir=#{man}", "install"
  end

  test do
    test_image = test_fixtures("test.jpg")
    assert_match "couldn't find Exif data",
                 shell_output("#{bin}/exiftags #{test_image} 2>&1", 1)
  end
end
