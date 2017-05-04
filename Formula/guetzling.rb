class Guetzling < Formula
  desc "Tool to automate image compression using the Guetzli algorithm."
  homepage "https://github.com/lejacobroy/Guetzling/tree/1.0.0"
  url "https://github.com/lejacobroy/Guetzling/archive/1.0.0.tar.gz"
  sha256 "a645587ad55916a1e977fb4b457390d6bef354e6b871b3a21514a9501e3a870f"

  bottle do
    cellar :any_skip_relocation
    sha256 "72c6bd387b0e1cac7ac22d34cf973d2acb9fe8ca635dd99fc24168830377d52f" => :sierra
    sha256 "30525ad6bca6dbe29f975150a519fe7f932a9f64ce9106d8144fe4be295f8d3b" => :el_capitan
    sha256 "30525ad6bca6dbe29f975150a519fe7f932a9f64ce9106d8144fe4be295f8d3b" => :yosemite
  end

  depends_on "guetzli"

  def install
    bin.install "guetzling"
  end

  test do
    system "curl", "http://i.imgur.com/BljEIfj.jpg"
    system "#{bin}/guetzling"
    system "true"
  end
end
