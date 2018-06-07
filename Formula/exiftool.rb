class Exiftool < Formula
  desc "Perl lib for reading and writing EXIF metadata"
  homepage "https://www.sno.phy.queensu.ca/~phil/exiftool/index.html"
  # Ensure release is tagged production before submitting.
  # https://www.sno.phy.queensu.ca/~phil/exiftool/history.html
  url "https://www.sno.phy.queensu.ca/~phil/exiftool/Image-ExifTool-11.00.tar.gz"
  mirror "https://downloads.sourceforge.net/project/exiftool/Image-ExifTool-11.00.tar.gz"
  sha256 "07f00780290eac5d9f00792ec16df845292b0cd7f8e7715146b753f761a37b57"

  bottle do
    cellar :any_skip_relocation
    sha256 "c664e75f4e08ec9e73beadb888c49ac1cbaf306d539ffdc66558f56a5eee8ffe" => :high_sierra
    sha256 "c664e75f4e08ec9e73beadb888c49ac1cbaf306d539ffdc66558f56a5eee8ffe" => :sierra
    sha256 "c664e75f4e08ec9e73beadb888c49ac1cbaf306d539ffdc66558f56a5eee8ffe" => :el_capitan
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
