class Ccal < Formula
  desc "Create Chinese calendars for print or browsing"
  homepage "https://ccal.chinesebay.com/ccal"
  url "https://ccal.chinesebay.com/ccal/ccal-2.5.3.tar.gz"
  sha256 "3d4cbdc9f905ce02ab484041fbbf7f0b7a319ae6a350c6c16d636e1a5a50df96"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "f0eaf9de33696838f910e372c56b9492bc4df32437cbd03bff9d1457e51b8989" => :high_sierra
    sha256 "0ffb91e757308734219cb34e3a5f07b03b2219fbb8a08dbe95bcafbd934e7ef7" => :sierra
    sha256 "eecae43921cb0ad4b5168c43eefb548ca635ce708e360c3d8b998862633724c3" => :el_capitan
  end

  def install
    system "make", "-e", "BINDIR=#{bin}", "install"
    system "make", "-e", "MANDIR=#{man}", "install-man"
  end

  test do
    assert_match "Year JiaWu, Month 1X", shell_output("#{bin}/ccal 2 2014")
  end
end
