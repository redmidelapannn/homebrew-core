class Osslsigncode < Formula
  desc "Authenticode signing of PE(EXE/SYS/DLL/etc), CAB and MSI files"
  homepage "https://sourceforge.net/projects/osslsigncode/"
  url "https://downloads.sourceforge.net/project/osslsigncode/osslsigncode/osslsigncode-1.7.1.tar.gz"
  sha256 "f9a8cdb38b9c309326764ebc937cba1523a3a751a7ab05df3ecc99d18ae466c9"

  bottle do
    cellar :any
    revision 1
    sha256 "ed69f3ff0b8144a10a66cbe0a1986717a5564415768530110ae66749777f3490" => :el_capitan
    sha256 "88c6d568585e98bba957a9637a6c2d4ca91c062e0de3c395e3956f71fd25099f" => :yosemite
    sha256 "8a96b1d7359a8dfda0ce4d4ba3464b349cd06d8e74d660633a28b31a2430dcb6" => :mavericks
  end

  head do
    url "http://git.code.sf.net/p/osslsigncode/osslsigncode.git"
    depends_on "automake" => :build
  end

  depends_on "pkg-config" => :build
  depends_on "autoconf" => :build
  depends_on "openssl"
  depends_on "libgsf" => :optional

  def install
    system "autoreconf", "-ivf" if build.head?
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    # Requires Windows PE executable as input, so we're just showing the version
    assert_match "osslsigncode", shell_output("#{bin}/osslsigncode --version", 255)
  end
end
