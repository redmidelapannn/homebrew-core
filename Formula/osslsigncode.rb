class Osslsigncode < Formula
  desc "Authenticode signing of PE(EXE/SYS/DLL/etc), CAB and MSI files"
  homepage "https://sourceforge.net/projects/osslsigncode/"
  url "https://downloads.sourceforge.net/project/osslsigncode/osslsigncode/osslsigncode-1.7.1.tar.gz"
  sha256 "f9a8cdb38b9c309326764ebc937cba1523a3a751a7ab05df3ecc99d18ae466c9"

  bottle do
    cellar :any
    rebuild 1
    sha256 "93b41400967b93c85f899034d123772e0924df1de2095fe77f4cbd9af71db0a4" => :sierra
    sha256 "029f8a5f6ba3f4d0c0d27e1333c331a6b1a08d18bc6f4141b005977e45d385da" => :el_capitan
    sha256 "66642e9a77b5e16c72de716da66089a2204a278b0ff612a1c244a42357f35592" => :yosemite
  end

  head do
    url "https://git.code.sf.net/p/osslsigncode/osslsigncode.git"
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
