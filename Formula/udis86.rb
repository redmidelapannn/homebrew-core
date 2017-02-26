class Udis86 < Formula
  desc "Minimalistic disassembler library for x86"
  homepage "https://udis86.sourceforge.io"
  url "https://downloads.sourceforge.net/udis86/udis86-1.7.2.tar.gz"
  sha256 "9c52ac626ac6f531e1d6828feaad7e797d0f3cce1e9f34ad4e84627022b3c2f4"

  bottle do
    cellar :any
    rebuild 1
    sha256 "6a9b43e99925de9943e95d1df2a48969838e712730736269e6596161a7a1db8a" => :sierra
    sha256 "29f9f275f30163f8dc612a5fd3a4d8a819711323845bd60220a71c44dca5aaee" => :el_capitan
    sha256 "972419c5e589417fce3d236a1c3f72eb61d8536464a4435f6a1e455855f1b321" => :yosemite
  end

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--enable-shared"
    system "make"
    system "make", "install"
  end

  test do
    assert_match("int 0x80", pipe_output("#{bin}/udcli -x", "cd 80").split.last(2).join(" "))
  end
end
