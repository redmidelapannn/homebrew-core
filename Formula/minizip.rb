class Minizip < Formula
  desc "C library for zip/unzip via zLib"
  homepage "http://www.winimage.com/zLibDll/minizip.html"
  url "http://zlib.net/zlib-1.2.10.tar.gz"
  sha256 "8d7e9f698ce48787b6e1c67e6bff79e487303e66077e25cb9784ac8835978017"

  bottle do
    cellar :any
    sha256 "76fe6c2aa28272b4f7befa312615fd4e2f7632282cc78a37b46fa53df1714990" => :sierra
    sha256 "a8bc9c34837f19f570b0b79e202bd45dd94345f3caf605ec0cf4eb1a6f6b2bfd" => :el_capitan
    sha256 "df494b791137984171c79c63bbfe5ab941309f62a5e12757442d7eb5c53e620c" => :yosemite
    sha256 "c03fd8e43919572a7b4ed71ad160f07e9ccbabc81e3a1f9dfb7b27b540f25bf1" => :mavericks
  end

  option :universal

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build

  def install
    ENV.universal_binary if build.universal?
    system "./configure", "--prefix=#{prefix}"
    system "make"

    cd "contrib/minizip" do
      # edits to statically link to libz.a
      inreplace "Makefile.am" do |s|
        s.sub! "-L$(zlib_top_builddir)", "$(zlib_top_builddir)/libz.a"
        s.sub! "-version-info 1:0:0 -lz", "-version-info 1:0:0"
        s.sub! "libminizip.la -lz", "libminizip.la"
      end
      system "autoreconf", "-fi"
      system "./configure", "--prefix=#{prefix}"
      system "make", "install"
    end
  end

  def caveats
    <<-EOS.undent
      Minizip headers installed in 'minizip' subdirectory, since they conflict
      with the venerable 'unzip' library.
    EOS
  end
end
