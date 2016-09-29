class Exiftool < Formula
  desc "Perl lib for reading and writing EXIF metadata"
  homepage "http://www.sno.phy.queensu.ca/~phil/exiftool/index.html"
  # Ensure release is tagged production before submitting.
  # http://www.sno.phy.queensu.ca/~phil/exiftool/history.html
  url "http://www.sno.phy.queensu.ca/~phil/exiftool/Image-ExifTool-10.20.tar.gz"
  sha256 "f06ae200950cd3f441f20f7532163365965aa45a91d96114672b0eb176b76d2a"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "a4a9af7c0ce95d399538a81b64f58cf13dffbc44e89f62af5e9510ca06a50789" => :sierra
    sha256 "a4a9af7c0ce95d399538a81b64f58cf13dffbc44e89f62af5e9510ca06a50789" => :el_capitan
    sha256 "a4a9af7c0ce95d399538a81b64f58cf13dffbc44e89f62af5e9510ca06a50789" => :yosemite
  end

  devel do
    url "http://www.sno.phy.queensu.ca/~phil/exiftool/Image-ExifTool-10.25.tar.gz"
    sha256 "edc2de5848375f7ccb88cd7d0260c98c4c581ffd509c4c249949f0cd1f522dd0"
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
