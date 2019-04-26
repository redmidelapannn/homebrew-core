class Liblo < Formula
  desc "Lightweight Open Sound Control implementation"
  homepage "https://liblo.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/liblo/liblo/0.30/liblo-0.30.tar.gz"
  sha256 "30a7c9de49a25ed7f2425a7a7415f5b14739def62431423d3419ea26fb978d1b"

  bottle do
    cellar :any
    sha256 "618fbbbd5fd7b4a28612d3686248eabf63ccbe8bb7f32770d6306dcd112451fa" => :mojave
    sha256 "16aa74bfdce6bcca8dbd94ab38b2cc22ee6c9b7ec95a8a8417abcd4a49b0d26b" => :high_sierra
    sha256 "2fc45228b8f97f952f5adfb4b706d54b6da0b5a77ab74b5f898e30aaf05a5e4c" => :sierra
  end

  head do
    url "https://git.code.sf.net/p/liblo/git.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  def install
    args = %W[
      --disable-debug
      --disable-dependency-tracking
      --prefix=#{prefix}
    ]

    if build.head?
      system "./autogen.sh", *args
    else
      system "./configure", *args
    end

    system "make", "install"
  end
end
