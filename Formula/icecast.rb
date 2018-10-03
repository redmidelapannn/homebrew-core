class Icecast < Formula
  desc "Streaming MP3 audio server"
  homepage "https://icecast.org/"
  url "https://downloads.xiph.org/releases/icecast/icecast-2.4.3.tar.gz"
  sha256 "c85ca48c765d61007573ee1406a797ae6cb31fb5961a42e7f1c87adb45ddc592"

  bottle do
    cellar :any
    rebuild 1
    sha256 "7da8add25e972811fbdd34dc8dff6d0173c81be94c9a0ceb88d21ad18187fd6a" => :mojave
    sha256 "e70740290546b9a30c6b330736bb4aa012803c6041de3b8200e9864849406910" => :high_sierra
  end

  depends_on "pkg-config" => :build
  depends_on "libvorbis"
  depends_on "openssl"
  depends_on "libogg" => :optional
  depends_on "speex"  => :optional
  depends_on "theora" => :optional

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"

    (prefix+"var/log/icecast").mkpath
    touch prefix+"var/log/icecast/error.log"
  end
end
