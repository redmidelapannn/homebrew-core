class RingsRepl < Formula
  desc "Rings: efficient Java/Scala library for polynomial rings"
  homepage "http://ringsalgebra.io/"
  url "https://raw.githubusercontent.com/PoslavskySV/rings/v.2.0.1/rings.repl/rings.repl", :using => :nounzip
  sha256 "fe3fc145deb1750160c0a9b6098ea80a92ec0a841304b94da1af0e94143b1c00"

  bottle do
    cellar :any_skip_relocation
    sha256 "89bcadc4f71929b9979f5bf21f85080aa1244a9b465036f650f278f16f24fe33" => :high_sierra
    sha256 "b60d43bd0011d288dbfe99359c1a9aac47b4537da55c27055312bd4ef1b81d86" => :sierra
    sha256 "432c7d4c8ccdebf32ce739ff5b72f43d4566a2bdb300137a79868ca0dd860e8d" => :el_capitan
  end

  depends_on "ammonite-repl"

  def install
    bin.install "rings.repl"
  end

  test do
    system "#{bin}/rings.repl", "-v"
  end
end
