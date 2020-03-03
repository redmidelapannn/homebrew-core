class Cmus < Formula
  desc "Music player with an ncurses based interface"
  homepage "https://cmus.github.io/"
  url "https://github.com/cmus/cmus/archive/v2.8.0.tar.gz"
  sha256 "756ce2c6241b2104dc19097488225de559ac1802a175be0233cfb6fbc02f3bd2"
  revision 1
  head "https://github.com/cmus/cmus.git"

  bottle do
    rebuild 2
    sha256 "39f5a7a89e0ec5f9311ee3429b5467a31fde3aac8a5648f5bea3405de520dd28" => :catalina
    sha256 "ac837c2f4b488440e4602a9c5c9ab1bbeeddc7b9eff93be1c857ef3d60e2f59f" => :mojave
    sha256 "85682062f2faf91b761dd6858266778f9d6d47ea5154fda4ccc7a8dfb0746a6e" => :high_sierra
  end

  depends_on "pkg-config" => :build
  depends_on "faad2"
  depends_on "ffmpeg"
  depends_on "flac"
  depends_on "libcue"
  depends_on "libogg"
  depends_on "libvorbis"
  depends_on "mad"
  depends_on "mp4v2"
  depends_on "opusfile"
  depends_on "pulseaudio" => :optional

  def install
    system "./configure", "prefix=#{prefix}", "mandir=#{man}"
    system "make", "install"
  end

  test do
    system "#{bin}/cmus", "--plugins"
  end
end
