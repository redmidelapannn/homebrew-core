class CdDiscid < Formula
  desc "Read CD and get CDDB discid information"
  homepage "http://linukz.org/cd-discid.shtml"
  revision 2
  head "https://github.com/taem/cd-discid.git"

  stable do
    url "http://linukz.org/download/cd-discid-1.4.tar.gz"
    mirror "https://deb.debian.org/debian/pool/main/c/cd-discid/cd-discid_1.4.orig.tar.gz"
    sha256 "ffd68cd406309e764be6af4d5cbcc309e132c13f3597c6a4570a1f218edd2c63"

    # macOS fix; see https://github.com/Homebrew/homebrew/issues/46267
    # Already fixed in upstream head; remove when bumping version to >1.4
    patch do
      url "https://raw.githubusercontent.com/Homebrew/formula-patches/85fa66a9/cd-discid/1.4.patch"
      sha256 "f53b660ae70e91174ab86453888dbc3b9637ba7fcaae4ea790855b7c3d3fe8e6"
    end
  end

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "cc9dacef243401352e562216dded0cb1ad2dddd2bbd8a89f2d7fb2d2818c4ff2" => :catalina
    sha256 "4e0a8fb9bd76519ec930b37b1a0a2064db3499bc65bd93c0368f43745199faef" => :mojave
    sha256 "e5d774581ec2e78fa39022836cb7cc2612111f3370ea2df90215a8d9909ab07b" => :high_sierra
  end

  def install
    system "make", "CC=#{ENV.cc}"
    bin.install "cd-discid"
    man1.install "cd-discid.1"
  end

  test do
    assert_equal "cd-discid #{version}.", shell_output("#{bin}/cd-discid --version 2>&1").chomp
  end
end
