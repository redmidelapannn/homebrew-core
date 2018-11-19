class Tbox < Formula
  desc "Glib-like multi-platform c library"
  homepage "https://tboox.org/"
  url "https://github.com/waruqi/tbox/archive/v1.6.3.tar.gz"
  sha256 "1ea225195ad6d41a29389137683fee7a853fa42f3292226ddcb6d6d862f5b33c"
  head "https://github.com/waruqi/tbox.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "fbb3b3c18d8c25d170770f5c2afc260556210087b181086410b8cd8f0fe15911" => :mojave
    sha256 "481320de915a78d3a42e1637435c4d6931f23f33f17de713d42559d76eba6461" => :high_sierra
    sha256 "3aa6af6828035145227b1ace22853ac774fbd619084bb4f049e6c226c84f449e" => :sierra
  end

  depends_on "xmake" => :build

  def install
    system "xmake", "config", "--charset=y", "--demo=n", "--small=y", "--xml=y"
    system "xmake", "install", "-o", prefix
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <tbox/tbox.h>
      int main()
      {
        if (tb_init(tb_null, tb_null))
        {
          tb_trace_i("hello tbox!");
          tb_exit();
        }
        return 0;
      }
    EOS
    system ENV.cc, "test.c", "-L#{lib}", "-ltbox", "-I#{include}", "-o", "test"
    system "./test"
  end
end
