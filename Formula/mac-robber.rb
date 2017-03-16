class MacRobber < Formula
  desc "Digital investigation tool"
  homepage "https://www.sleuthkit.org/mac-robber/"
  url "https://downloads.sourceforge.net/project/mac-robber/mac-robber/1.02/mac-robber-1.02.tar.gz"
  sha256 "5895d332ec8d87e15f21441c61545b7f68830a2ee2c967d381773bd08504806d"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "a5394f80be051229a6a676687f7aa49442f4d264806c1fcac69df78c277c8267" => :sierra
    sha256 "764a12db87db453f9c13cdfb9ce456c8d032c84d373444b0463dd475d8a03cc4" => :el_capitan
    sha256 "dddfc1f0544f18a01602baf398fb269e0f9185b1b71f66b3e7e8b15aab0461cb" => :yosemite
  end

  def install
    system "make", "CC=#{ENV.cc}", "GCC_OPT=#{ENV.cflags}"
    bin.install "mac-robber"
  end
end
