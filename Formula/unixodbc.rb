class Unixodbc < Formula
  desc "ODBC 3 connectivity for UNIX"
  homepage "http://www.unixodbc.org/"
  url "http://www.unixodbc.org/unixODBC-2.3.7.tar.gz"
  sha256 "45f169ba1f454a72b8fcbb82abd832630a3bf93baa84731cf2949f449e1e3e77"
  revision 1

  bottle do
    sha256 "041fa5e8db89fd3000713b48df44c97b15ce5290dcd4ec7b656c26be4342fc34" => :catalina
    sha256 "98e852c04a13d0a020113e1359cac14a453320b81e9f026936af5cb19d0a2cfb" => :mojave
    sha256 "b9fa166afb09b99b8dd1bdf13a6943323b1f11d3f5a6144964b35e992237f923" => :high_sierra
  end

  depends_on "libiconv"
  depends_on "libtool"

  conflicts_with "libiodbc", :because => "both install 'odbcinst.h' header"
  conflicts_with "virtuoso", :because => "Both install `isql` binaries."

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--sysconfdir=#{etc}",
                          "--enable-static",
                          "--enable-gui=no",
                          "--with-libiconv-prefix=#{Formula["libiconv"].prefix}"
    system "make", "install"
  end

  test do
    system bin/"odbcinst", "-j"
    (testpath/"test.c").write <<~EOS
      #include <sql.h>
      int main() {
          SQLFreeConnect(0);
          return 0;
      }
    EOS
    system ENV.cc, "test.c", "#{lib}/libodbc.a", "#{Formula["libtool"].lib}/libltdl.a", "#{Formula["libiconv"].lib}/libiconv.a", "-o", "test"
    system "./test"
  end
end
