class Suil < Formula
  desc "lightweight C library for loading and wrapping LV2 plugin UIs"
  homepage "https://drobilla.net/software/suil/"
  url "https://download.drobilla.net/suil-0.8.2.tar.bz2"
  sha256 "787608c1e5b1f5051137dbf77c671266088583515af152b77b45e9c3a36f6ae8"

  bottle do
    rebuild 2
    sha256 "9148a186b94ec906cc3e724898b3c4d22cc5e95ec20868b5808655b60b729b26" => :sierra
    sha256 "a1964c1b674e71d30290f2b0fadb76b4114c6b04e30a00fcc4404f7e8c8736cd" => :el_capitan
    sha256 "e482422f94a65516bff92406751587b698566e2e457fa263f6637841673e72e8" => :yosemite
  end

  depends_on "pkg-config" => :build
  depends_on "lv2"
  depends_on "gtk+" => :recommended
  depends_on :x11 => :optional

  def install
    system "./waf", "configure", "--prefix=#{prefix}"
    system "./waf", "install"
  end

  test do
    (testpath/"test.c").write <<-EOS.undent
      #include <suil/suil.h>

      int main()
      {
        return suil_ui_supported("my-host", "my-ui");
      }
    EOS
    lv2 = Formula["lv2"].opt_include
    system ENV.cc, "-I#{lv2}", "-I#{include}/suil-0", "-L#{lib}", "-lsuil-0", "test.c", "-o", "test"
    system "./test"
  end
end
