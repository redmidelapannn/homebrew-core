class Libmodbus < Formula
  desc "Portable modbus library"
  homepage "http://libmodbus.org"
  url "http://libmodbus.org/releases/libmodbus-3.1.4.tar.gz"
  mirror "https://librecmc.org/librecmc/downloads/sources/v1.3.4/libmodbus-3.1.4.tar.gz"
  sha256 "c8c862b0e9a7ba699a49bc98f62bdffdfafd53a5716c0e162696b4bf108d3637"

  bottle do
    cellar :any
    rebuild 1
    sha256 "edad7a2f8db99bb7fe47b9167835c3128f738b5e620cbbd21bbdf886d942a17e" => :sierra
    sha256 "303baa1c9591262a84bad4c7747560595820db65ce5a0b832f152d89495bd90b" => :el_capitan
    sha256 "da698bf052ad9afcc65a4a5e9e5fdd47b1f4d48a0421ffd5ed45d423be38b6a8" => :yosemite
  end

  head do
    url "https://github.com/stephane/libmodbus.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  def install
    system "./autogen.sh" if build.head?
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"hellomodbus.c").write <<-EOS.undent
      #include <modbus.h>
      #include <stdio.h>
      int main() {
        modbus_t *mb;
        uint16_t tab_reg[32];

        mb = 0;
        mb = modbus_new_tcp("127.0.0.1", 1502);
        modbus_connect(mb);

        /* Read 5 registers from the address 0 */
        modbus_read_registers(mb, 0, 5, tab_reg);

        void *p = mb;
        modbus_close(mb);
        modbus_free(mb);
        mb = 0;
        return (p == 0);
      }
    EOS
    system ENV.cc, "hellomodbus.c", "-o", "foo", "-lmodbus",
      "-I#{include}/libmodbus", "-I#{include}/modbus"
    system "./foo"
  end
end
