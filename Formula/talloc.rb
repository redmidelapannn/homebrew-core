class Talloc < Formula
  desc "Hierarchical, reference-counted memory pool with destructors"
  homepage "https://talloc.samba.org/"
  url "https://www.samba.org/ftp/talloc/talloc-2.1.9.tar.gz"
  mirror "https://sources.voidlinux.eu/talloc-2.1.9/talloc-2.1.9.tar.gz"
  sha256 "f0aad4cb88a3322207c82136ddc07bed48a37c2c21f82962d6c5ccb422711062"

  bottle do
    cellar :any
    rebuild 1
    sha256 "9be9af8308c3db57c1c1f17d57c1dfa94d3214f555edfdf651eb5adf7f13feac" => :sierra
    sha256 "d05488468f3ad04aa7a7cab78d53c1cc0cd011fef0325371d570d6802407d110" => :el_capitan
    sha256 "bba100de47750612085cc577d0fce250d9fef306b64c72a2408f89d13a73ee68" => :yosemite
  end

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--disable-rpath",
                          "--without-gettext",
                          "--disable-python"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<-EOS.undent
      #include <talloc.h>
      int main()
      {
        int ret;
        TALLOC_CTX *tmp_ctx = talloc_new(NULL);
        if (tmp_ctx == NULL) {
          ret = 1;
          goto done;
        }
        ret = 0;
      done:
        talloc_free(tmp_ctx);
        return ret;
      }
    EOS
    system ENV.cc, "-I#{include}", "-L#{lib}", "-ltalloc", "test.c", "-o", "test"
    system testpath/"test"
  end
end
