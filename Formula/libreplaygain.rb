class Libreplaygain < Formula
  desc "Library to implement ReplayGain standard for audio"
  homepage "https://www.musepack.net/"
  url "https://files.musepack.net/source/libreplaygain_r475.tar.gz"
  version "r475"
  sha256 "8258bf785547ac2cda43bb195e07522f0a3682f55abe97753c974609ec232482"

  bottle do
    cellar :any
    revision 2
    sha256 "e5cd3766d4f886679813999d5bb9bdd92de797525f11785ee306ed51108c3f89" => :el_capitan
    sha256 "67c4045710628ff131350fc3bd6c153a541e87b4afc90cf992317c704cec42db" => :yosemite
    sha256 "a1a134ef390d33b549c35fb624ef92f7877786de79efa96be8ee136aa348ec6f" => :mavericks
  end

  depends_on "cmake" => :build

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
    include.install "include/replaygain/"
  end
end
