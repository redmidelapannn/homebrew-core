class Exiftool < Formula
  desc "Perl lib for reading and writing EXIF metadata"
  homepage "http://www.sno.phy.queensu.ca/~phil/exiftool/index.html"
  # Ensure release is tagged production before submitting.
  # http://www.sno.phy.queensu.ca/~phil/exiftool/history.html
  url "http://www.sno.phy.queensu.ca/~phil/exiftool/Image-ExifTool-10.60.tar.gz"
  sha256 "df0988f60e1a6c086799e1f2ecd419e8abbad4dfb5dfa66c6080c78a5cb7acfa"

  bottle do
    cellar :any_skip_relocation
    sha256 "615aa37533fb3e8c8a185d81a34f71ab80fbfe0556db3884a2d9bb9e1ea1218b" => :sierra
    sha256 "615aa37533fb3e8c8a185d81a34f71ab80fbfe0556db3884a2d9bb9e1ea1218b" => :el_capitan
    sha256 "615aa37533fb3e8c8a185d81a34f71ab80fbfe0556db3884a2d9bb9e1ea1218b" => :yosemite
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
