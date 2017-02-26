class Libsodium < Formula
  desc "NaCl networking and cryptography library"
  homepage "https://github.com/jedisct1/libsodium/"
  url "https://github.com/jedisct1/libsodium/releases/download/1.0.11/libsodium-1.0.11.tar.gz"
  sha256 "a14549db3c49f6ae2170cbbf4664bd48ace50681045e8dbea7c8d9fb96f9c765"

  bottle do
    cellar :any
    rebuild 1
    sha256 "7bc137761bc860552465dc416173b4c9880aed36b1b135627db30574f23cd088" => :sierra
    sha256 "c518b54d83e0a5394b82dbc5022851f97e284255c5598a4d30686d209e038768" => :el_capitan
    sha256 "40b9f135ea7447556c53f74100a9663211d7800e70e1647dbc34004fae6b4a67" => :yosemite
  end

  head do
    url "https://github.com/jedisct1/libsodium.git"

    depends_on "libtool" => :build
    depends_on "autoconf" => :build
    depends_on "automake" => :build
  end

  def install
    system "./autogen.sh" if build.head?
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "check"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<-EOS.undent
      #include <assert.h>
      #include <sodium.h>

      int main()
      {
        assert(sodium_init() != -1);
        return 0;
      }
    EOS
    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}",
                   "-lsodium", "-o", "test"
    system "./test"
  end
end
