class Libmowgli < Formula
  desc "Core framework for Atheme applications"
  homepage "https://github.com/atheme/libmowgli-2"
  url "https://github.com/atheme/libmowgli-2/archive/v2.1.3.tar.gz"
  sha256 "b7faab2fb9f46366a52b51443054a2ed4ecdd04774c65754bf807c5e9bdda477"
  revision 1
  head "https://github.com/atheme/libmowgli-2.git"

  bottle do
    cellar :any
    sha256 "2de85808eaf2fe1a68fd2d05bf9501fc52fab96168140e06b1b03302e257e1fa" => :high_sierra
    sha256 "5b84ce0cc6379b780801aa37b03bbe1fd6a6f842abf71a21cda92bb07ea9d1af" => :sierra
    sha256 "67eb0d07b277fb96633003fe33d721b3d2955c2fdb298f16dfd3b83d3ce8b79d" => :el_capitan
  end

  depends_on "openssl@1.1"

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--with-openssl=#{Formula["openssl@1.1"].opt_prefix}"
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <mowgli.h>

      int main(int argc, char *argv[]) {
        char buf[65535];
        mowgli_random_t *r = mowgli_random_create();
        mowgli_formatter_format(buf, 65535, "%1! %2 %3 %4.",\
                    "sdpb", "Hello World", mowgli_random_int(r),\
                    0xDEADBEEF, TRUE);
        puts(buf);
        mowgli_object_unref(r);
        return EXIT_SUCCESS;
      }
    EOS
    system ENV.cc, "-I#{include}/libmowgli-2", "-o", "test", "test.c", "-L#{lib}", "-lmowgli-2"
    system "./test"
  end
end
