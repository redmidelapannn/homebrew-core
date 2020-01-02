class Opensc < Formula
  desc "Tools and libraries for smart cards"
  homepage "https://github.com/OpenSC/OpenSC/wiki"
  url "https://github.com/OpenSC/OpenSC/releases/download/0.20.0/opensc-0.20.0.tar.gz"
  sha256 "bbf4b4f4a44463645c90a525e820a8059b2f742a53b7b944f941de3c97ba4863"
  head "https://github.com/OpenSC/OpenSC.git"

  bottle do
    sha256 "e499235404c11f8b0cdeb0a75f9384d0cb854b1e4ea1d4e9c6a9da9117447e2d" => :catalina
    sha256 "aef1ca8666ec50558f3631d98cb1985570b751e54d6fc6d44679ebdfdb917a33" => :mojave
    sha256 "b27e321b2255e7b97efd3e1ac45c2a51264f84a6cca581da533dc28ea95c197b" => :high_sierra
    sha256 "f6cb9f0abe5a48c71d8c0adc00a741bcac48807a272f712ae7685b74da8535fe" => :sierra
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "docbook-xsl" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "openssl@1.1"

  def install
    args = %W[
      --disable-dependency-tracking
      --prefix=#{prefix}
      --enable-openssl
      --enable-pcsc
      --enable-sm
      --with-xsl-stylesheetsdir=#{Formula["docbook-xsl"].opt_prefix}/docbook-xsl
    ]

    system "./bootstrap"
    system "./configure", *args
    system "make", "install"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/opensc-tool -i")
  end
end
