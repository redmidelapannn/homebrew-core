class Exiftool < Formula
  desc "Perl lib for reading and writing EXIF metadata"
  homepage "https://www.sno.phy.queensu.ca/~phil/exiftool/index.html"
  # Ensure release is tagged production before submitting.
  # https://www.sno.phy.queensu.ca/~phil/exiftool/history.html
  url "https://www.sno.phy.queensu.ca/~phil/exiftool/Image-ExifTool-10.55.tar.gz"
  mirror "https://downloads.sourceforge.net/project/exiftool/Image-ExifTool-10.55.tar.gz"
  sha256 "029b81a43f423332c00b76b5402fd8f85dee975fad41a734b494faeda4e41f7d"
  revision 1

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "e0b1506842db7455fb63dfd6b75b8e4a439a363c4f9fa770172c779ac83bf834" => :high_sierra
    sha256 "e0b1506842db7455fb63dfd6b75b8e4a439a363c4f9fa770172c779ac83bf834" => :sierra
    sha256 "e0b1506842db7455fb63dfd6b75b8e4a439a363c4f9fa770172c779ac83bf834" => :el_capitan
  end

  devel do
    url "https://sno.phy.queensu.ca/~phil/exiftool/Image-ExifTool-10.69.tar.gz"
    mirror "https://downloads.sourceforge.net/project/exiftool/Image-ExifTool-10.69.tar.gz"
    sha256 "c24c50380eeb648e2c932a869ebc0e31189bb49ea450c822fad00bf5e6072aea"
  end

  def install
    # replace the hard-coded path to the lib directory
    inreplace "exiftool", "$exeDir/lib", libexec/"lib"

    system "perl", "Makefile.PL"
    system "make", "all"
    libexec.install "lib"
    bin.install "exiftool"
    doc.install Dir["html/*"]
    man1.install "blib/man1/exiftool.1"
    man3.install Dir["blib/man3/*"]
  end

  test do
    test_image = test_fixtures("test.jpg")
    assert_match %r{MIME Type\s+: image/jpeg},
                 shell_output("#{bin}/exiftool #{test_image}")
  end
end
