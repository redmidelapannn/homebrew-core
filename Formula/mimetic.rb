class Mimetic < Formula
  desc "C++ MIME library"
  homepage "http://www.codesink.org/mimetic_mime_library.html"
  url "http://www.codesink.org/download/mimetic-0.9.8.tar.gz"
  sha256 "3a07d68d125f5e132949b078c7275d5eb0078dd649079bd510dd12b969096700"

  bottle do
    cellar :any
    revision 1
    sha256 "e2813309b97984e8498b25cd56a514eb45e1cd6d12cf7aa765cbbc0559d9cde0" => :el_capitan
    sha256 "8f74e080694bd20ebf4bd714ec18f5d11a626bc17ae7e5bcc15ce05cbc216e1a" => :yosemite
    sha256 "1252dbaabfa34bb641dbbd6c4fa296807810e53a72f10770514a057e2299a31b" => :mavericks
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<-EOS.undent
      #include <iostream>
      #include <mimetic/mimetic.h>

      using namespace std;
      using namespace mimetic;

      int main()
      {
            MimeEntity me;
            me.header().from("me <me@domain.com>");
            me.header().to("you <you@domain.com>");
            me.header().subject("my first mimetic msg");
            me.body().assign("hello there!");
            cout << me << endl;
            return 0;
      }
    EOS
    system ENV.cxx, "test.cpp", "-L#{lib}", "-lmimetic", "-o", "test"
    system "./test"
  end
end
