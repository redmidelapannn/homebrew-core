class Libcddb < Formula
  desc "CDDB server access library"
  homepage "https://libcddb.sourceforge.io/"
  url "https://downloads.sourceforge.net/libcddb/libcddb-1.3.2.tar.bz2"
  sha256 "35ce0ee1741ea38def304ddfe84a958901413aa829698357f0bee5bb8f0a223b"
  revision 3

  bottle do
    cellar :any
    rebuild 1
    sha256 "d1531120e92ca6849ddcd33c80a6eba6ec0dd5814d68146d8f6ddd4bd1390c7b" => :high_sierra
    sha256 "debc601a1fce76626fb4534cfdf406be9c7ddec8eda4e8f18e5005db652f275d" => :sierra
    sha256 "ed334caa96dfda1d68a157ce3536ac72c44d3b9ab7a114e5eb7321d7383ee025" => :el_capitan
  end

  depends_on "pkg-config" => :build
  depends_on "libcdio"

  def install
    if MacOS.version == :yosemite && MacOS::Xcode.installed? && MacOS::Xcode.version >= "7.0"
      ENV.delete("SDKROOT")
    end

    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <cddb/cddb.h>
      int main(void) {
        cddb_track_t *track = cddb_track_new();
        cddb_track_destroy(track);
      }
    EOS
    system ENV.cc, "test.c", "-L#{lib}", "-lcddb", "-o", "test"
    system "./test"
  end
end
