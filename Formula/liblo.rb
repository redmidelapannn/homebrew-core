class Liblo < Formula
  desc "Lightweight Open Sound Control implementation"
  homepage "https://liblo.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/liblo/liblo/0.28/liblo-0.28.tar.gz"
  sha256 "da94a9b67b93625354dd89ff7fe31e5297fc9400b6eaf7378c82ee1caf7db909"

  bottle do
    cellar :any
    rebuild 3
    sha256 "0d33507b56b92e595734e199db96ab85805dc5f3f52a2d994a623ba2be5d9dfc" => :sierra
    sha256 "38390fce00aed3cff5d692ecb48ad41ec19665a348879d7f44c32c29451e5c9a" => :el_capitan
    sha256 "6329cfc6dc521988c3073727c6db3d664d5d53e8e9482f5e4745ecd36e742ee8" => :yosemite
  end

  head do
    url "https://git.code.sf.net/p/liblo/git.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  option "with-ipv6", "Compile with support for ipv6"

  deprecated_option "enable-ipv6" => "with-ipv6"

  def install
    args = %W[
      --disable-debug
      --disable-dependency-tracking
      --prefix=#{prefix}
    ]

    args << "--enable-ipv6" if build.with? "ipv6"

    if build.head?
      system "./autogen.sh", *args
    else
      system "./configure", *args
    end

    system "make", "install"
  end
end
