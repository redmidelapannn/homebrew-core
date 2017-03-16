class Lasso < Formula
  desc "Library for Liberty Alliance and SAML protocols"
  homepage "https://www.entrouvert.com/"
  url "https://dev.entrouvert.org/releases/lasso/lasso-2.5.1.tar.gz"
  sha256 "be105c8d400ddeb798419eafa9522101d0f63dc42b79b7131b6010c4a5fc2058"

  bottle do
    cellar :any
    rebuild 1
    sha256 "d61d48ecba8656d06705984bd95c4cc79d595233ae83680684f7554bde957806" => :sierra
    sha256 "a840503b37869ee6a6a43841eed7b2932ad75e5becd7d54359b062336a8bc859" => :el_capitan
    sha256 "01015e9df323f337279f178228f3abb8aefccdb14a97217c3b4f3eba69d2583f" => :yosemite
  end

  depends_on "pkg-config" => :build
  depends_on "libxmlsec1"
  depends_on "glib"
  depends_on "openssl"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--disable-java",
                          "--disable-perl",
                          "--disable-php5",
                          "--disable-python",
                          "--prefix=#{prefix}",
                          "--with-pkg-config=#{ENV["PKG_CONFIG_PATH"]}"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<-EOS.undent
      #include <lasso/lasso.h>

      int main() {
        return lasso_init();
      }
    EOS
    system ENV.cc, "test.c",
                   "-I#{Formula["glib"].include}/glib-2.0",
                   "-I#{Formula["glib"].lib}/glib-2.0/include",
                   "-I#{MacOS.sdk_path}/usr/include/libxml2",
                   "-I#{Formula["libxmlsec1"].include}/xmlsec1",
                   "-L#{lib}", "-llasso", "-o", "test"
    system "./test"
  end
end
