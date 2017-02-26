class Liblo < Formula
  desc "Lightweight Open Sound Control implementation"
  homepage "https://liblo.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/liblo/liblo/0.28/liblo-0.28.tar.gz"
  sha256 "da94a9b67b93625354dd89ff7fe31e5297fc9400b6eaf7378c82ee1caf7db909"

  bottle do
    cellar :any
    rebuild 3
    sha256 "a2a9f2d2d7d69726b9351c0cec97e6db50ee0796312b3d28d350619240a63d9e" => :sierra
    sha256 "019c51132a78cd40759d138d3959250a196554add5874cb8b46809d61eb746e7" => :el_capitan
    sha256 "2d660507d3bc4689e846c88dfeed4d4ac70804d0d8d0481315029def9b26c3e2" => :yosemite
  end

  head do
    url "git://liblo.git.sourceforge.net/gitroot/liblo/liblo"

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
