class Expat < Formula
  desc "XML 1.0 parser"
  homepage "https://expat.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/expat/expat/2.2.0/expat-2.2.0.tar.bz2"
  mirror "https://fossies.org/linux/www/expat-2.2.0.tar.bz2"
  sha256 "d9e50ff2d19b3538bd2127902a89987474e1a4db8e43a66a4d1a712ab9a504ff"
  head "https://github.com/libexpat/libexpat.git"

  bottle do
    cellar :any
    rebuild 1
    sha256 "651c9787c2058e929273040f81dc56b59f89ee0c20f4bf27e699204f34dffac2" => :sierra
    sha256 "c1857b498b75dab25281c5b257e50750ae9d1d7f4b808387042deb6b84dccc23" => :el_capitan
    sha256 "e5351bad414045f1efb38dc570044ad2465c037b7f0ec190dafdbfc2ebbd6e03" => :yosemite
  end

  keg_only :provided_by_osx, "macOS includes Expat 1.5."

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--mandir=#{man}"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<-EOS.undent
      #include <stdio.h>
      #include "expat.h"

      static void XMLCALL my_StartElementHandler(
        void *userdata,
        const XML_Char *name,
        const XML_Char **atts)
      {
        printf("tag:%s|", name);
      }

      static void XMLCALL my_CharacterDataHandler(
        void *userdata,
        const XML_Char *s,
        int len)
      {
        printf("data:%.*s|", len, s);
      }

      int main()
      {
        static const char str[] = "<str>Hello, world!</str>";
        int result;

        XML_Parser parser = XML_ParserCreate("utf-8");
        XML_SetElementHandler(parser, my_StartElementHandler, NULL);
        XML_SetCharacterDataHandler(parser, my_CharacterDataHandler);
        result = XML_Parse(parser, str, sizeof(str), 1);
        XML_ParserFree(parser);

        return result;
      }
    EOS
    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-lexpat", "-o", "test"
    assert_equal "tag:str|data:Hello, world!|", shell_output("./test")
  end
end
