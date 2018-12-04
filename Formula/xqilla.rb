class Xqilla < Formula
  desc "XQuery and XPath 2 command-line interpreter"
  homepage "https://xqilla.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/xqilla/XQilla-2.3.4.tar.gz"
  sha256 "292631791631fe2e7eb9727377335063a48f12611d641d0296697e0c075902eb"
  revision 1

  bottle do
    cellar :any
    sha256 "2e432c12ab4ebe6ee09410c1b4ed634a9fd04d2381d16c26a8211fccfbd078c2" => :mojave
    sha256 "dd9cc7e77a336b9d1322673cd4319646eece4be95c173018ea6ea23697a9d31f" => :high_sierra
    sha256 "c7898d6c10e564720dd1ab4fb9c050d11912d73d5a0b6181c5434e240846882b" => :sierra
  end

  depends_on "xerces-c"

  conflicts_with "zorba", :because => "Both supply xqc.h"

  needs :cxx11

  def install
    ENV.cxx11

    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--with-xerces=#{HOMEBREW_PREFIX}",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <iostream>
      #include <xqilla/xqilla-simple.hpp>

      int main(int argc, char *argv[]) {
        XQilla xqilla;
        AutoDelete<XQQuery> query(xqilla.parse(X("1 to 100")));
        AutoDelete<DynamicContext> context(query->createDynamicContext());
        Result result = query->execute(context);
        Item::Ptr item;
        while(item == result->next(context)) {
          std::cout << UTF8(item->asString(context)) << std::endl;
        }
        return 0;
      }
    EOS
    system ENV.cxx, "-I#{include}", "-L#{lib}", "-lxqilla",
           "-I#{Formula["xerces-c"].opt_include}",
           "-L#{Formula["xerces-c"].opt_lib}", "-lxerces-c",
           testpath/"test.cpp", "-o", testpath/"test"
    system testpath/"test"
  end
end
