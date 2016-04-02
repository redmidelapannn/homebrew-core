class Libsodium < Formula
  desc "NaCl networking and cryptography library"
  homepage "https://github.com/jedisct1/libsodium/"
  url "https://github.com/jedisct1/libsodium/releases/download/1.0.9/libsodium-1.0.9.tar.gz"
  sha256 "611418db78c36b2e20e50363d30e9c002a98dea9322f305b5bde56a26cdfe756"

  bottle do
    cellar :any
    sha256 "22da801a70d02c1bb5ea4c96edaeaae9abf5fbc1af6b1d90e8f16480fd1b4acb" => :el_capitan
    sha256 "94b249ba9615ac43333f8020db42b959147126279d4accf015064dae4459abac" => :yosemite
    sha256 "431dbd7fdea912104abeea7d61671cb025829d88093e7394b7f9375f0413d552" => :mavericks
  end

  head do
    url "https://github.com/jedisct1/libsodium.git"

    depends_on "libtool" => :build
    depends_on "autoconf" => :build
    depends_on "automake" => :build
  end

  option :universal

  def install
    ENV.universal_binary if build.universal?

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
    system ENV.cc, "test.c", "-lsodium", "-o", "test"
    system "./test"
  end
end
