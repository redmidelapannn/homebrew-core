class Exiftool < Formula
  desc "Perl lib for reading and writing EXIF metadata"
  homepage "https://www.sno.phy.queensu.ca/~phil/exiftool/index.html"
  # Ensure release is tagged production before submitting.
  # https://www.sno.phy.queensu.ca/~phil/exiftool/history.html
  url "https://www.sno.phy.queensu.ca/~phil/exiftool/Image-ExifTool-10.55.tar.gz"
  sha256 "029b81a43f423332c00b76b5402fd8f85dee975fad41a734b494faeda4e41f7d"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "e86f70977fd46396c7a89155e6c16bb24e1e35dda5beb805802a5ba99bf06318" => :sierra
    sha256 "e86f70977fd46396c7a89155e6c16bb24e1e35dda5beb805802a5ba99bf06318" => :el_capitan
    sha256 "e86f70977fd46396c7a89155e6c16bb24e1e35dda5beb805802a5ba99bf06318" => :yosemite
  end

  def install
    # replace the hard-coded path to the lib directory
    inreplace "exiftool", "$exeDir/lib", libexec/"lib"

    system "perl", "Makefile.PL"
    libexec.install "lib"
    bin.install "exiftool"
  end

  test do
    test_image = test_fixtures("test.jpg")
    assert_match %r{MIME Type\s+: image/jpeg},
                 shell_output("#{bin}/exiftool #{test_image}")
  end
end
