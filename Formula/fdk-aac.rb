class FdkAac < Formula
  desc "Standalone library of the Fraunhofer FDK AAC code from Android"
  homepage "https://sourceforge.net/projects/opencore-amr/"
  url "https://downloads.sourceforge.net/project/opencore-amr/fdk-aac/fdk-aac-0.1.5.tar.gz"
  sha256 "2164592a67b467e5b20fdcdaf5bd4c50685199067391c6fcad4fa5521c9b4dd7"

  bottle do
    cellar :any
    rebuild 1
    sha256 "1b75b5ac2245a043a79ce1064db4be27eb88eacdf14483fb6958d93d52ca9dd8" => :sierra
    sha256 "b0b42f63ed17c54843aa2d79a056dc37b629376f71b5dda89b742d69cbc7ad2e" => :el_capitan
    sha256 "1c5686038446832e6c05d65090eb882d8fc7a4a0e0e8bd45022d3d0bdfe0bf81" => :yosemite
  end

  head do
    url "https://git.code.sf.net/p/opencore-amr/fdk-aac.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  def install
    system "./autogen.sh" if build.head?
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--enable-example"
    system "make", "install"
  end

  test do
    system "#{bin}/aac-enc", test_fixtures("test.wav"), "test.aac"
    assert File.exist?("test.aac")
  end
end
