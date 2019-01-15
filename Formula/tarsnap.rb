class Tarsnap < Formula
  desc "Online backups for the truly paranoid"
  homepage "https://www.tarsnap.com/"
  url "https://www.tarsnap.com/download/tarsnap-autoconf-1.0.39.tgz"
  sha256 "5613218b2a1060c730b6c4a14c2b34ce33898dd19b38fb9ea0858c5517e42082"

  bottle do
    cellar :any
    rebuild 1
    sha256 "6396b4d60e70745b703cac7ce902a49b78bfe50ae57575cfbc5e7a7a1821d8b4" => :mojave
    sha256 "4801f6de8ea9037931c1950c904c0b0787f596694a7e5f8d8ea948616ae9127d" => :high_sierra
    sha256 "5f60e01a1fb5ae9a60c8b5e9cf286c78ca24ccf760211ea6a67fbfe5a5804c06" => :sierra
  end

  head do
    url "https://github.com/Tarsnap/tarsnap.git"
    depends_on "autoconf" => :build
    depends_on "automake" => :build
  end

  depends_on "openssl"

  def install
    # dyld: lazy symbol binding failed: Symbol not found: _clock_gettime
    # Reported 20 Aug 2017 https://github.com/Tarsnap/tarsnap/issues/286
    if MacOS.version == :el_capitan && MacOS::Xcode.installed? && MacOS::Xcode.version >= "8.0"
      inreplace "libcperciva/util/monoclock.c", "CLOCK_MONOTONIC",
                                                "UNDEFINED_GIBBERISH"
    end

    system "autoreconf", "-iv" if build.head?

    args = %W[
      --disable-dependency-tracking
      --disable-silent-rules
      --prefix=#{prefix}
      --sysconfdir=#{etc}
      --with-bash-completion-dir=#{bash_completion}
      --without-lzma
      --without-lzmadec
    ]

    system "./configure", *args
    system "make", "install"
  end

  test do
    system bin/"tarsnap", "-c", "--dry-run", testpath
  end
end
