class Mednafen < Formula
  desc "Multi-system emulator"
  homepage "https://mednafen.github.io/"
  url "https://mednafen.github.io/releases/files/mednafen-1.24.1.tar.xz"
  sha256 "a47adf3faf4da66920bebb9436e28cbf87ff66324d0bb392033cbb478b675fe7"

  bottle do
    sha256 "f6439b981d6cc228cbebd9f4ab93522bde107d9d1431fe5b5eccc5155a66c325" => :catalina
    sha256 "7dd0b6ea63dfa301b1c168cd84ace0d4a0a3487247c16b9f8864a7dcfcd9e867" => :mojave
    sha256 "9a197bd302ddd4603850d7a71db3b047adede31da82171bab386c994576e08aa" => :high_sierra
  end

  depends_on "pkg-config" => :build
  depends_on "gettext"
  depends_on "libsndfile"
  depends_on :macos => :sierra # needs clock_gettime
  depends_on "sdl2"

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-dependency-tracking"
    system "make", "install"
  end

  test do
    cmd = "#{bin}/mednafen | head -n1 | grep -o '[0-9].*'"
    assert_equal version.to_s, shell_output(cmd).chomp
  end
end
