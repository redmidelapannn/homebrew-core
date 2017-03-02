class Cmus < Formula
  desc "Music player with an ncurses based interface"
  homepage "https://cmus.github.io/"
  url "https://github.com/cmus/cmus/archive/v2.7.1.tar.gz"
  sha256 "8179a7a843d257ddb585f4c65599844bc0e516fe85e97f6f87a7ceade4eb5165"
  revision 2
  head "https://github.com/cmus/cmus.git"

  bottle do
    rebuild 1
    sha256 "585f719bbfc4a639ca053987a20b4095c4c05e42afd8ef4e5e719b418a68ea96" => :sierra
    sha256 "0b39a5395adedee4bfb921495149da2177c22ba245a5a99617bf3a3fb288b8cf" => :el_capitan
    sha256 "c2b6d7c31371e641c0b1a1c6ae197efce3875667506c348aba5d97d1f5e78f72" => :yosemite
  end

  devel do
    url "https://github.com/cmus/cmus/archive/v2.8.0-rc0.tar.gz"
    sha256 "b594087f16053f4db49e89d72b1c6dbb12e221373e806e62b3e97c327de1dac9"
    version "2.8.0-rc0"
  end

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

  def install
    system "./configure", "prefix=#{prefix}", "mandir=#{man}"
    system "make", "install"
  end

  test do
    system "#{bin}/cmus", "--plugins"
  end
end
