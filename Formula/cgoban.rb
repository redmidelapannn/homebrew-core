class Cgoban < Formula
  desc "Go-related services"
  homepage "https://cgoban1.sourceforge.io/"
  url "https://web.archive.org/web/20190926163208/www.igoweb.org/~wms/comp/cgoban/cgoban-1.9.12.tar.gz"
  sha256 "b9e8b0d2f793fecbc26803d673de11d8cdc88af9d286a6d49b7523f8b4fa20e1"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "6270ce26bcc430553edb53ea9591a31e112e197ff1303e8802370cc0f17151f4" => :catalina
    sha256 "30288451ee59de5f94000b3a07946bdc21f64907278545b1f2ebfeb8b89b8636" => :mojave
    sha256 "4b9863194da434f636025abf7392e6c5604eb35d28b19836b4493049d13041f8" => :high_sierra
  end

  depends_on :x11

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules"

    bin.mkpath
    man6.mkpath

    system "make", "install", "PREFIX=#{prefix}", "MANDIR=#{man}"
  end

  test do
    system "#{bin}/cgoban", "--version"
  end
end
