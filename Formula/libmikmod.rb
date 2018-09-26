class Libmikmod < Formula
  desc "Portable sound library"
  homepage "https://mikmod.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/mikmod/libmikmod/3.3.11.1/libmikmod-3.3.11.1.tar.gz"
  sha256 "ad9d64dfc8f83684876419ea7cd4ff4a41d8bcd8c23ef37ecb3a200a16b46d19"

  bottle do
    cellar :any
    rebuild 1
    sha256 "b8b2691fd8a1985102fa04d3b519e5b22d919144c02ba6429091c86eb6851b67" => :mojave
    sha256 "81ab0ff6d772d3c8a3486b8e37bf7c8f254ab7676f2573ed3f196cb983cd5f0b" => :high_sierra
    sha256 "ae1a3872736424b2d74c99bbfa4e2a04fa281b4a6859670eba1272647d8acdc9" => :sierra
  end

  def install
    mkdir "macbuild" do
      # macOS has CoreAudio, but ALSA, SAM9407 and ULTRA are not supported
      system "../configure", "--prefix=#{prefix}", "--disable-alsa",
                             "--disable-sam9407", "--disable-ultra"
      system "make", "install"
    end
  end

  test do
    system "#{bin}/libmikmod-config", "--version"
  end
end
