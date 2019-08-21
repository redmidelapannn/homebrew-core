class Exiftool < Formula
  desc "Perl lib for reading and writing EXIF metadata"
  homepage "https://www.sno.phy.queensu.ca/~phil/exiftool/index.html"
  # Ensure release is tagged production before submitting.
  # https://www.sno.phy.queensu.ca/~phil/exiftool/history.html
  url "https://www.sno.phy.queensu.ca/~phil/exiftool/Image-ExifTool-11.63.tar.gz"
  sha256 "71ba7f6412b807b751b05d613d06f92875caa61adadd0227465cb3819fe64c5b"

  bottle do
    cellar :any_skip_relocation
    sha256 "61d2b8def2451a4e4b30e8c2d89939694f5eba0b5c8e8f2b2caba66b81c2b7d4" => :mojave
    sha256 "2375b5c2a6461ed0f307eade7cfeec83a1e0ed2f805bc99e4335424e277b4def" => :high_sierra
    sha256 "bf7527e2c5c499262df72cbe571cc2ddf19d9e48de42fb332aca419a6b71e7ef" => :sierra
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
