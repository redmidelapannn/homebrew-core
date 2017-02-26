class Libmikmod < Formula
  desc "Portable sound library"
  homepage "http://mikmod.shlomifish.org"
  url "https://downloads.sourceforge.net/project/mikmod/libmikmod/3.3.10/libmikmod-3.3.10.tar.gz"
  sha256 "00b3f5298431864ebd069de793ec969cfea3ae6f340f6dfae1ff7da1ae24ef48"

  bottle do
    cellar :any
    rebuild 1
    sha256 "f7b397782014f337d316eb260da3c8c7014fc28f4179ea80e50afd9dc15c9de3" => :sierra
    sha256 "7e524792978db006bbc95c376fd9e959bc03b696de56d8dc0e4c61df02ad251e" => :el_capitan
    sha256 "7b86ffe852086372159b959a22129435093fd40dd2199b36e192a2dcd3a89525" => :yosemite
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
