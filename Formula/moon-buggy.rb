class MoonBuggy < Formula
  desc "Drive some car across the moon"
  homepage "https://www.seehuhn.de/pages/moon-buggy.html"

  stable do
    url "https://m.seehuhn.de/programs/moon-buggy-1.0.tar.gz"
    sha256 "f8296f3fabd93aa0f83c247fbad7759effc49eba6ab5fdd7992f603d2d78e51a"
  end
  bottle do
    rebuild 1
    sha256 "0289822bb9d59360dc7cb04d08b4b9e2ee83b4ec42d66a4ceea7d5b221dd0630" => :high_sierra
    sha256 "28043a45f26969e5e698c17ac7566a3e1c0da23c75105e3fefde169b7687e54d" => :sierra
    sha256 "df3a8f9203cf10acd3e3a64f643f73cefc37c4ee7f7fb6ee404d12834d6242e5" => :el_capitan
  end

  devel do
    url "https://m.seehuhn.de/programs/moon-buggy-1.0.51.tar.gz"
    sha256 "352dc16ccae4c66f1e87ab071e6a4ebeb94ff4e4f744ce1b12a769d02fe5d23f"
  end

  head do
    url "https://github.com/seehuhn/moon-buggy.git"
    depends_on "autoconf" => :build
    depends_on "automake" => :build
  end

  def install
    system "./autogen.sh" if build.head?
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}",
                          "--infodir=#{info}"
    system "make", "install"
  end

  test do
    assert_match /Moon-Buggy #{version}$/, shell_output("#{bin}/moon-buggy -V")
  end
end
