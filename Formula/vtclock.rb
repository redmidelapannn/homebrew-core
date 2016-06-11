class Vtclock < Formula
  desc "Text-mode fullscreen digital clock"
  homepage "https://webonastick.com/vtclock/"
  url "https://webonastick.com/vtclock/vtclock-2005-02-20.tar.gz"
  version "2005-02-20"
  sha256 "5fcbceff1cba40c57213fa5853c4574895755608eaf7248b6cc2f061133dab68"

  bottle do
    cellar :any_skip_relocation
    revision 1
    sha256 "f87c685e59533a0085b439c4153c2734d4091447f5a81c627ccc0d2e589ac65d" => :el_capitan
    sha256 "a72a8c176276c40a3e9b0c6083a61013efb55b5ea43cd786000dad3c4243dd96" => :yosemite
    sha256 "b9b7d30a1ab36022bfdd7612b6ca1e0d10650286e20a9d8ff1cfab2c421c1b7d" => :mavericks
  end

  def install
    system "make"
    bin.install "vtclock"
  end

  test do
    system "#{bin}/vtclock", "-h"
  end
end
