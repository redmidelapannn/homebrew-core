class Libshout < Formula
  desc "Data and connectivity library for the icecast server"
  homepage "https://icecast.org/"
  url "https://downloads.xiph.org/releases/libshout/libshout-2.4.1.tar.gz"
  sha256 "f3acb8dec26f2dbf6df778888e0e429a4ce9378a9d461b02a7ccbf2991bbf24d"

  bottle do
    cellar :any
    rebuild 1
    sha256 "ab3a619c6292777332249b0faea95da35db03331443547d4733cc487cbeac063" => :high_sierra
    sha256 "26a57e5dcb49ca60240ac26f6a7afd5d18728f5baec278579693dac07df974b4" => :sierra
    sha256 "88edf4c6b89875dab164278b88928fc79b6cffd7908871a3b42a6794f319643f" => :el_capitan
  end

  depends_on "pkg-config" => :build
  depends_on "libogg"
  depends_on "libvorbis"
  depends_on "theora"
  depends_on "speex"

  def install
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make", "install"
  end
end
