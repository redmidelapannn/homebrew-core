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
    sha256 "2721a624ad9c5a93fe30a9b5eb8203b595b3c4d6ca907de34ccdf47a220baab7" => :high_sierra
    sha256 "2721a624ad9c5a93fe30a9b5eb8203b595b3c4d6ca907de34ccdf47a220baab7" => :sierra
    sha256 "2721a624ad9c5a93fe30a9b5eb8203b595b3c4d6ca907de34ccdf47a220baab7" => :el_capitan
  end

  devel do
    url "https://www.sno.phy.queensu.ca/~phil/exiftool/Image-ExifTool-10.64.tar.gz"
    mirror "https://downloads.sourceforge.net/project/exiftool/Image-ExifTool-10.64.tar.gz"
    sha256 "1632a684fa93bc1051f3ffab9cf9453c2b5e29173afd8b91b1044e4def8c42c9"
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
