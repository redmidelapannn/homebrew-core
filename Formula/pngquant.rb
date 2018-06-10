class Pngquant < Formula
  desc "PNG image optimizing utility"
  homepage "https://pngquant.org/"
  url "https://pngquant.org/pngquant-2.12.0-src.tar.gz"
  sha256 "0e540c64bb58c05f2a05b4eaf1d3d165f0d3278500f15abfeac47f93f8fa8fa8"
  head "https://github.com/kornelski/pngquant.git"

  bottle do
    cellar :any
    rebuild 1
    sha256 "02799136d5a059b64d10fb4dc3aa1c134e3267051969a254e7235eaf05f21d85" => :high_sierra
    sha256 "ff8f49b1d31ad876ec08b9ca0d8fef3f07fadeaaf3a01002e6703bc8163eb93b" => :sierra
    sha256 "daf9ff8ad895be6b4a25fd13304b2dd7aecec13e06966eb160dfdc46eeabc09f" => :el_capitan
  end

  depends_on "pkg-config" => :build
  depends_on "rust" => :build
  depends_on "libpng"
  depends_on "little-cms2"

  def install
    system "cargo", "install", "--root", prefix
    man1.install "pngquant.1"
  end

  test do
    system "#{bin}/pngquant", test_fixtures("test.png"), "-o", "out.png"
    assert_predicate testpath/"out.png", :exist?
  end
end
