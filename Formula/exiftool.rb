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
    sha256 "b65b5a01b4a0bae5348d7fbe3ada1ad0649f813112309c438bfa7bcd7be3b34e" => :high_sierra
    sha256 "b65b5a01b4a0bae5348d7fbe3ada1ad0649f813112309c438bfa7bcd7be3b34e" => :sierra
    sha256 "b65b5a01b4a0bae5348d7fbe3ada1ad0649f813112309c438bfa7bcd7be3b34e" => :el_capitan
  end

  devel do
    url "https://sno.phy.queensu.ca/~phil/exiftool/Image-ExifTool-10.78.tar.gz"
    mirror "https://downloads.sourceforge.net/project/exiftool/Image-ExifTool-10.78.tar.gz"
    sha256 "06d34e17824db5f496760690705eeeb0aaa4f1cdb701d9ffb78e863a12c68e10"
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
