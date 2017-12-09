class Pianobar < Formula
  desc "Command-line player for https://pandora.com"
  homepage "https://github.com/PromyLOPh/pianobar/"
  url "https://6xq.net/pianobar/pianobar-2017.08.30.tar.bz2"
  sha256 "ec14db6cf1a7dbc1d8190b5ca0d256021e970587bcdaeb23904d4bca71a04674"
  revision 1
  head "https://github.com/PromyLOPh/pianobar.git"

  bottle do
    cellar :any
    sha256 "94e14ea567e84c04b6828303f1aed2afd468157173ecd44f2b43b9c99ef2dbfd" => :high_sierra
    sha256 "a446487ee656df0cb00f75af34cd86c5b8eba93d8d3cd88a75df399d6554ebb3" => :sierra
    sha256 "6b18140deb9f39c42a884cba3a93c7d3c68ea6250c58b52829dc725e4f10bf8c" => :el_capitan
  end

  depends_on "pkg-config" => :build
  depends_on "libao"
  depends_on "mad"
  depends_on "faad2"
  depends_on "gnutls"
  depends_on "libgcrypt"
  depends_on "json-c"
  depends_on "ffmpeg"

  def install
    # Discard Homebrew's CFLAGS as Pianobar reportedly doesn't like them
    ENV["CFLAGS"] = "-O2 -DNDEBUG " +
                    # Or it doesn't build at all
                    "-std=c99 " +
                    # build if we aren't /usr/local'
                    "#{ENV.cppflags} #{ENV.ldflags}"
    system "make", "PREFIX=#{prefix}"
    system "make", "install", "PREFIX=#{prefix}"

    prefix.install "contrib"
  end
end
