class Opensc < Formula
  desc "Tools and libraries for smart cards"
  homepage "https://github.com/OpenSC/OpenSC/wiki"
  url "https://github.com/OpenSC/OpenSC/releases/download/0.18.0/opensc-0.18.0.tar.gz"
  sha256 "9bc0ff030dd1c10f646d54415eae1bb2b1c72dda710378343f027e17cd8c3757"
  head "https://github.com/OpenSC/OpenSC.git"

  bottle do
    rebuild 1
    sha256 "60bae9a4ffbfe97e0c72dfd839745bd91bb092a63971996bd5e1c2497d7f7154" => :mojave
    sha256 "9cdac92e0d4a9bc261efad160e08cb15d6c96ae451f06bb7b93c1e29ff2e2218" => :high_sierra
    sha256 "84b15e220c3e4556ae7b47d59c75d95c9e163610ae1d2100b04a0b1f0fd86db6" => :sierra
    sha256 "cb537d8157c361401ad6c611e491032696da718829bfde8f1887cb76f7634920" => :el_capitan
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "docbook-xsl" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "openssl"

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
end
