class Augeas < Formula
  desc "Configuration editing tool and API"
  homepage "http://augeas.net"
  url "http://download.augeas.net/augeas-1.12.0.tar.gz"
  sha256 "321942c9cc32185e2e9cb72d0a70eea106635b50269075aca6714e3ec282cb87"

  bottle do
    rebuild 1
    sha256 "10e0bacd3f3ced1bd6daf01d5c598c93c0c58aa1ac56c9a7e15a369acdf6c5d8" => :mojave
    sha256 "1c65830ce8aef09e84cc3c703593b07b946fb871061e4143e52f86cf1c1b7775" => :high_sierra
    sha256 "64b71b299ba29b52fcb32dd7383c023ce226d7d6f9a2873c6ee8ee57988a7c9f" => :sierra
  end

  head do
    url "https://github.com/hercules-team/augeas.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "bison" => :build
    depends_on "libtool" => :build
  end

  depends_on "pkg-config" => :build
  depends_on "readline"
  uses_from_macos "libxml2"

  def install
    args = %W[--disable-debug --disable-dependency-tracking --prefix=#{prefix}]

    if build.head?
      system "./autogen.sh", *args
    else
      system "./configure", *args
    end

    system "make", "install"
  end

  def caveats; <<~EOS
    Lenses have been installed to:
      #{HOMEBREW_PREFIX}/share/augeas/lenses/dist
  EOS
  end

  test do
    system bin/"augtool", "print", etc
  end
end
