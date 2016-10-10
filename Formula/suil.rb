class Suil < Formula
  desc "lightweight C library for loading and wrapping LV2 plugin UIs"
  homepage "https://drobilla.net/software/suil/"
  url "https://download.drobilla.net/suil-0.8.2.tar.bz2"
  sha256 "787608c1e5b1f5051137dbf77c671266088583515af152b77b45e9c3a36f6ae8"

  bottle do
    rebuild 2
    sha256 "44bccfdf5bc4dabac8468ae447943b2c86b815bb916664b16f652fd05ce4786b" => :sierra
    sha256 "92551fd036d7c86087f9d26ac1770b1f8901f930086f5e00477bf9a7b4a21b96" => :el_capitan
    sha256 "124f5ddf653516b3440fb917a72a1ba1b4c334c1831446678d570e51de9eefec" => :yosemite
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
    system ENV.cc, "-I#{include}/suil-0", "-L#{lib}", "-lsuil-0", "test.c", "-o", "test"
    system "./test"
  end
end
