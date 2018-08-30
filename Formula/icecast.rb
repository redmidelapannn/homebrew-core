class Icecast < Formula
  desc "Streaming MP3 audio server"
  homepage "https://icecast.org/"
  url "https://downloads.xiph.org/releases/icecast/icecast-2.4.3.tar.gz"
  sha256 "c85ca48c765d61007573ee1406a797ae6cb31fb5961a42e7f1c87adb45ddc592"

  bottle do
    cellar :any
    rebuild 1
    sha256 "bbaad981097fdc7d3ea7b22e492446b153d16630676df3b7c0667a2c3dc9cc09" => :mojave
    sha256 "65889aa735a3b6007bedf7f957aa086cf019723d16067e6fcc33fae8c401a97f" => :high_sierra
    sha256 "2352ff9e57fd0aaba39a1f3aae506d4a5656e0deace07287a882e57c8a9063c4" => :el_capitan
  end

  depends_on "pkg-config" => :build
  depends_on "libogg" => :optional
  depends_on "theora" => :optional
  depends_on "speex"  => :optional
  depends_on "openssl"
  depends_on "libvorbis"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"

    (prefix+"var/log/icecast").mkpath
    touch prefix+"var/log/icecast/error.log"
  end
end
