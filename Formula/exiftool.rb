class Exiftool < Formula
  desc "Perl lib for reading and writing EXIF metadata"
  homepage "https://www.sno.phy.queensu.ca/~phil/exiftool/index.html"
  # Ensure release is tagged production before submitting.
  # https://www.sno.phy.queensu.ca/~phil/exiftool/history.html
  url "https://www.sno.phy.queensu.ca/~phil/exiftool/Image-ExifTool-11.60.tar.gz"
  sha256 "f71f8896d7a045a416d3683de9bdb01e5e15dd171fb4ffeab3c2778d37ad4382"

  bottle do
    cellar :any_skip_relocation
    sha256 "fa48d5e94fbc95ac63eae93473b4f0e1864e954354953562fb4c4cbb1f2e8d0b" => :mojave
    sha256 "36edccd255f14fde34a0f87db0043b4036a52cdac712fbe2ce5e70b14e407ee9" => :high_sierra
    sha256 "c9bf5a56dafa5594452d34218cb35c8e27e6300a8ba187b7c7253291f5de17f5" => :sierra
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
