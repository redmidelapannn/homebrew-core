class Dmalloc < Formula
  desc "Debug versions of system memory management routines"
  homepage "https://dmalloc.com/"
  url "https://dmalloc.com/releases/dmalloc-5.5.2.tgz"
  sha256 "d3be5c6eec24950cb3bd67dbfbcdf036f1278fae5fd78655ef8cdf9e911e428a"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "dd7278ff25f50ec5dbd7667c7f34b94d2cda3c000237d6b6a9d76a6fb8eafc2c" => :catalina
    sha256 "bf0dbebc2d86fa2abf775075b651338478c8af27bdd78bc9fcb2572d4d10bc1d" => :mojave
    sha256 "1749c979ca1640760691bf1de3332944e3daf7b23792398462d786162a90cabb" => :high_sierra
  end

  def install
    system "./configure", "--enable-threads", "--prefix=#{prefix}"
    system "make", "install", "installth", "installcxx", "installthcxx"
  end

  test do
    system "#{bin}/dmalloc", "-b", "runtime"
  end
end
