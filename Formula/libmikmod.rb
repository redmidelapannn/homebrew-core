class Libmikmod < Formula
  desc "Portable sound library"
  homepage "https://mikmod.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/mikmod/libmikmod/3.3.11.1/libmikmod-3.3.11.1.tar.gz"
  sha256 "ad9d64dfc8f83684876419ea7cd4ff4a41d8bcd8c23ef37ecb3a200a16b46d19"

  bottle do
    cellar :any
    rebuild 1
    sha256 "ef1b7d34a6e2e812d39c7ea7e0cdf80b0e7a6f159ddf57aefa43dd32a2eed5ea" => :high_sierra
    sha256 "3d549bc65e82b6ec86c05bbf1ad37f3a72b0be454543432ac1c6306f99b57df0" => :sierra
    sha256 "50001e7d21a2bb95c951ca7b047ba8a37446bc805f2eac4c16be987c9af55536" => :el_capitan
  end

  option "with-debug", "Enable debugging symbols"

  def install
    ENV.O2 if build.with? "debug"

    # macOS has CoreAudio, but ALSA is not for this OS nor is SAM9407 nor ULTRA.
    args = %W[
      --prefix=#{prefix}
      --disable-alsa
      --disable-sam9407
      --disable-ultra
    ]
    args << "--with-debug" if build.with? "debug"
    mkdir "macbuild" do
      system "../configure", *args
      system "make", "install"
    end
  end

  test do
    system "#{bin}/libmikmod-config", "--version"
  end
end
