class Cmus < Formula
  desc "Music player with an ncurses based interface"
  homepage "https://cmus.github.io/"
  url "https://github.com/cmus/cmus/archive/v2.7.1.tar.gz"
  sha256 "8179a7a843d257ddb585f4c65599844bc0e516fe85e97f6f87a7ceade4eb5165"
  revision 2
  head "https://github.com/cmus/cmus.git"

  bottle do
    rebuild 1
    sha256 "5be42d935e7a7de5856897a828ce6d06953c013e5b90ca10b87facff36fcbdc0" => :high_sierra
    sha256 "3d4fd4f1cddf5ad997b1988f53a0c466c3cc0cdd974690882ace0a9082cc6b32" => :sierra
    sha256 "c6a5afe4a3ce717a3280b4b2a206c6b65cf3bb12f69a7188d87456a2225545d1" => :el_capitan
  end

  devel do
    url "https://github.com/cmus/cmus/archive/v2.8.0-rc0.tar.gz"
    sha256 "b594087f16053f4db49e89d72b1c6dbb12e221373e806e62b3e97c327de1dac9"
  end

  option "with-ncurses", "Use Homebrew's version of ncurses"

  depends_on "pkg-config" => :build
  depends_on "libao"
  depends_on "mad"
  depends_on "libogg"
  depends_on "libvorbis"
  depends_on "faad2"
  depends_on "flac"
  depends_on "mp4v2"
  depends_on "libcue"
  depends_on "ffmpeg" => :optional
  depends_on "opusfile" => :optional
  depends_on "jack" => :optional
  depends_on "ncurses" => :optional

  def install
    system "./configure", "prefix=#{prefix}", "mandir=#{man}"
    system "make", "install"
  end

  test do
    system "#{bin}/cmus", "--plugins"
  end
end
