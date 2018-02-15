class Tcpreplay < Formula
  desc "Replay saved tcpdump files at arbitrary speeds"
  homepage "https://tcpreplay.appneta.com/"
  url "https://github.com/appneta/tcpreplay/releases/download/v4.2.6/tcpreplay-4.2.6.tar.gz"
  sha256 "043756c532dab93e2be33a517ef46b1341f7239278a1045ae670041dd8a4531d"

  bottle do
    cellar :any
    rebuild 1
    sha256 "224d4e83ed66ef7b58cdc0a95b235d33c37d8f5e9d17537b08e41cf6b03338dd" => :high_sierra
    sha256 "beacce916df1d07e5992ff727b88f80265c680963dfe2c1d1cc8e4e32b1841f9" => :sierra
    sha256 "3bac7fd782444372e6d51e4af0c92f9115053f9b5d67d15bcd6c8bbe8f1c0231" => :el_capitan
  end

  depends_on "libdnet"

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          "--enable-dynamic-link"
    system "make", "install"
  end

  test do
    system bin/"tcpreplay", "--version"
  end
end
