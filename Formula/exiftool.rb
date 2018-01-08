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
    sha256 "2fc538fe83bb101bebf87ceb1896b585756fd9b2f4556a4bcc9c43f8e218fd2b" => :high_sierra
    sha256 "2fc538fe83bb101bebf87ceb1896b585756fd9b2f4556a4bcc9c43f8e218fd2b" => :sierra
    sha256 "2fc538fe83bb101bebf87ceb1896b585756fd9b2f4556a4bcc9c43f8e218fd2b" => :el_capitan
  end

  devel do
    url "https://sno.phy.queensu.ca/~phil/exiftool/Image-ExifTool-10.74.tar.gz"
    mirror "https://downloads.sourceforge.net/project/exiftool/Image-ExifTool-10.74.tar.gz"
    sha256 "3948bf6fe4f55b87748c58756ebb83a3e15f9314f10e1b8dc67f2db8abfba56c"
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
