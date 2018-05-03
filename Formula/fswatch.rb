class Fswatch < Formula
  desc "Monitor a directory for changes and run a shell command"
  homepage "https://github.com/emcrisostomo/fswatch"
  url "https://github.com/emcrisostomo/fswatch/releases/download/1.11.3/fswatch-1.11.3.tar.gz"
  sha256 "21f60ff255bd8dac72c8eb917b08c10ef2a040b380876a35357f6a860282ac83"

  bottle do
    cellar :any
    sha256 "a9850136df474bb8d70499236285e61e8aa6a17557168d6107506e507cc22b8e" => :high_sierra
    sha256 "8fe64e87fe1269d8497d520aafb0f4543ac286656990a4a6785b526437adc9bd" => :sierra
    sha256 "ccc110c3c8f008abc615f96358119e8400c03190d785681197badd5f10e0a978" => :el_capitan
  end

  needs :cxx11

  def install
    ENV.cxx11
    system "./configure", "--prefix=#{prefix}",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules"
    system "make", "install"
  end

  test do
    system bin/"fswatch", "-h"
  end
end
