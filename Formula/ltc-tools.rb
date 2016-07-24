class LtcTools < Formula
  desc "Tools to deal with linear-timecode (LTC)"
  homepage "https://github.com/x42/ltc-tools"
  url "https://github.com/x42/ltc-tools/archive/v0.6.4.tar.gz"
  sha256 "8fc9621df6f43ab24c65752a9fee67bee6625027c19c088e5498d2ea038a22ec"
  revision 1
  head "https://github.com/x42/ltc-tools.git"

  bottle do
    cellar :any
    sha256 "579fdb41fe1d02c3ce639664adaf675cce63e977de50c16ecd098a57ed5565c7" => :el_capitan
    sha256 "96bc72ac23297de7c2b7f45dad729b610bd2b4fd719b6322c4445af950f3c05b" => :yosemite
    sha256 "f6c2119f6363d69c8b8192d35570d8fba094f024ae04d9ae3560b311507c4794" => :mavericks
  end

  depends_on "pkg-config" => :build
  depends_on "help2man" => :build
  depends_on "libltc"
  depends_on "libsndfile"
  depends_on "jack"

  def install
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    system bin/"ltcgen", "test.wav"
    system bin/"ltcdump", "test.wav"
  end
end
