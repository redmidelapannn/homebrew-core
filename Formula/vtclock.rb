class Vtclock < Formula
  desc "Text-mode fullscreen digital clock"
  homepage "https://webonastick.com/vtclock/"
  url "https://webonastick.com/vtclock/vtclock-2005-02-20.tar.gz"
  sha256 "5fcbceff1cba40c57213fa5853c4574895755608eaf7248b6cc2f061133dab68"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "b806c6c8ba01bed279519515f2af7cf26bcfb1651d6677c4a06c8c7154872876" => :sierra
    sha256 "42716a33383a6a19ce7a668c4b5dc32e502c0d10c0ab127544b9274b360dc501" => :el_capitan
    sha256 "8dd90a58fb9675a81f34a3b9f1779ac781ee254771ee1349fde1e5167ca930c4" => :yosemite
  end

  def install
    system "make"
    bin.install "vtclock"
  end

  test do
    system "#{bin}/vtclock", "-h"
  end
end
