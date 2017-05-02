class Duti < Formula
  desc "Select default apps for documents and URL schemes on macOS"
  homepage "https://github.com/russellhancox/duti"
  url "https://github.com/russellhancox/duti/archive/master.tar.gz"
  version "1.7"
  sha256 "65d604eaf9d5c1e6931d26e934c1bac6972bb6ccebc1e34a14f4d68c5b8a8c2c"
  head "https://github.com/russellhancox/duti.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "e0da729ae8011a5c58d581dbac5b3e18cc43b3a6e29f60165152185567d05575" => :sierra
    sha256 "eb52563006e046450fa8a8f4fe5ff8d6a095da4cd493aa0ca04ff13b6396fa32" => :el_capitan
    sha256 "500ed38b3360c398ae79ce32e2a448daa685e354e27029447b054446e51d17b8" => :yosemite
  end

  def install
    bin.mkpath
    system "make"
    bin.install "duti"
    man1.install "duti.1"
  end

  test do
    system "#{bin}/duti", "-x", "txt"
  end

end
