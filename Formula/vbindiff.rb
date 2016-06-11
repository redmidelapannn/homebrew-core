class Vbindiff < Formula
  desc "Visual Binary Diff"
  homepage "https://www.cjmweb.net/vbindiff/"
  url "https://www.cjmweb.net/vbindiff/vbindiff-3.0_beta4.tar.gz"
  version "3.0_beta4"
  sha256 "7d5d5a87fde953dc2089746f6f6ab811d60e127b01074c97611898fb1ef1983d"

  bottle do
    cellar :any_skip_relocation
    revision 1
    sha256 "73f69ac6f7cea7a406c3bf755b9780d7cd87cc46f2916b8224a34e521af6f58c" => :el_capitan
    sha256 "6de7c979e4fad911ac167ea47917d5758ff1a6c442d84395606425c47ff25e20" => :yosemite
    sha256 "8629291d1c8e415c894cedbde3a2e6ae26012b39a9d6e79b9b6cdb517ae984de" => :mavericks
  end

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/vbindiff", "-L"
  end
end
