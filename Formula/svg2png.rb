class Svg2png < Formula
  desc "SVG to PNG converter"
  homepage "https://cairographics.org/"
  url "https://cairographics.org/snapshots/svg2png-0.1.3.tar.gz"
  sha256 "e658fde141eb7ce981ad63d319339be5fa6d15e495d1315ee310079cbacae52b"

  bottle do
    cellar :any
    revision 1
    sha256 "258ad4ba971211f21ea22f9b361d9e277ac9764af30c4fbc8ebcc035589afd04" => :el_capitan
    sha256 "2f703da3770de11d731e1b8606f6b2e71b307ce6487a764f063728510a89b1f9" => :yosemite
    sha256 "1538cd78c90b37651b06a6602d54150ef13aee964fceea97473c4a2aedf6d74f" => :mavericks
  end

  depends_on "pkg-config" => :build
  depends_on "libsvg-cairo"

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}"
    system "make", "install"
  end

  test do
    system "#{bin}/svg2png", test_fixtures("test.svg"), "test.png"
    assert File.exist? "test.png"
  end
end
