class Libntlm < Formula
  desc "Implements Microsoft's NTLM authentication"
  homepage "https://www.nongnu.org/libntlm/"
  url "https://www.nongnu.org/libntlm/releases/libntlm-1.4.tar.gz"
  sha256 "8415d75e31d3135dc7062787eaf4119b984d50f86f0d004b964cdc18a3182589"

  bottle do
    cellar :any
    rebuild 2
    sha256 "ca5528d01eb7d7a174057484667fbb98179b6732641e06f143b2f30ceaab17f7" => :high_sierra
    sha256 "8b1556fbb3aa4f6dbd9a8651fa70ca33a62463057f005d5b2566f5523d73d31e" => :sierra
    sha256 "9ac53e29194f7711ee0970dfc958d76e0e164903d06a210a1ccf8b665f9baa11" => :el_capitan
  end

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end
end
