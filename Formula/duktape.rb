class Duktape < Formula
  desc "Embeddable Javascript engine with compact footprint"
  homepage "http://duktape.org"
  url "http://duktape.org/duktape-2.2.1.tar.xz"
  sha256 "3abe2eed2553305262b892c98f550bb1a94cf4fd73b51dc5c176fe08e7ade7f2"

  bottle do
    cellar :any
    sha256 "3741089d4609c60d571570ab16bf341f17271efaba2dd0489bd7b7abf677bbfa" => :high_sierra
    sha256 "83b0acbee2312f10aa9632449486ac0ab756505e16a1e473fe698fd1e3ea98ff" => :sierra
    sha256 "fa86c3bef321b0d8d60eb15599569690e898ea8c26dcf0e520b7b0aaf7628a26" => :el_capitan
  end

  def install
    inreplace "Makefile.sharedlibrary" do |s|
      s.gsub! "-soname", "-install_name"
      s.gsub! %r{\/usr\/local}, prefix
      s.gsub! "libduktape.so.$(REAL_VERSION)", "libduktape.$(REAL_VERSION).so"
      s.gsub! "libduktaped.so.$(REAL_VERSION)", "libduktaped.$(REAL_VERSION).so"
      s.gsub! "libduktape.so.$(SONAME_VERSION)", "libduktape.$(SONAME_VERSION).so"
      s.gsub! "libduktaped.so.$(SONAME_VERSION)", "libduktaped.$(SONAME_VERSION).so"
    end
    system "make", "-f", "Makefile.sharedlibrary"
    mkdir lib
    mkdir include
    system "make", "-f", "Makefile.sharedlibrary", "install"
  end

  test do
    (testpath/"test.cc").write <<~EOS
      #include <stdio.h>
      #include \"duktape.h\"
      int main(int argc, char *argv[]) {
        duk_context *ctx = duk_create_heap_default();
        duk_eval_string(ctx, \"1+2\");
        printf(\"1+2=%d\\n\", (int) duk_get_int(ctx, -1));
        duk_destroy_heap(ctx);
        return 0;
      }
    EOS
    system ENV.cc, "-I#{include}", "-lduktape",
           testpath/"test.cc", "-o", testpath/"test"
    assert_equal "1+2=3", shell_output(testpath/"test").strip, "Duktape can add number"
  end
end
