class Herrie < Formula
  desc "Minimalistic audio player built upon Ncurses"
  homepage "https://herrie.info/"
  url "https://github.com/EdSchouten/herrie/releases/download/herrie-2.2/herrie-2.2.tar.bz2"
  sha256 "142341072920f86b6eb570b8f13bf5fd87c06cf801543dc7d1a819e39eb9fb2b"

  bottle do
    rebuild 1
    sha256 "003332984f9448158d2d17740aafb6faf579694b188b3b1e0d2ac3436a494e9a" => :high_sierra
    sha256 "6ce1346e30feaebef505fba51c3660c71c68c61894f98920fe57206f01d6dce5" => :sierra
    sha256 "a2f97c130fb1cf6398969f3e5fea5602295a5ac055bb1edaa2129da860d4a30f" => :el_capitan
  end

  depends_on "pkg-config" => :build
  depends_on "gettext"
  depends_on "glib"
  depends_on "libvorbis"
  depends_on "libid3tag"
  depends_on "mad"
  depends_on "libsndfile"

  def install
    ENV["PREFIX"] = prefix
    system "./configure", "no_modplug", "no_xspf", "coreaudio", "ncurses"
    system "make", "install"
  end

  test do
    system "#{bin}/herrie", "-v"
  end
end
