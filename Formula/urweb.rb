class Urweb < Formula
  desc "Ur/Web programming language"
  homepage "http://www.impredicative.com/ur/"
  url "https://github.com/urweb/urweb/releases/download/20190217/urweb-20190217.tar.gz"
  sha256 "da24e093369a14ae738dfb08d83fcba083ce07360023f6f55734f0e335e880b2"

  bottle do
    sha256 "e480b2436c6b2f671c0c9a528774ef7ec9827d75eddab6be0fb5d82e0b56b5d7" => :catalina
    sha256 "6c7ea7615e075ca5a6f82fbc76e131d8d1313b163be54a03dea718f05b6d3f91" => :mojave
    sha256 "78519a46dead9a904c11731f92225b9cc730772333be172aa69d9c1a4771ebdb" => :high_sierra
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "mlton" => :build
  depends_on "gmp"
  depends_on "icu4c"
  depends_on "openssl@1.1"

  def install
    ENV.append "CFLAGS", "-I#{Formula["icu4c"].include}"

    args = %W[
      --disable-debug
      --disable-dependency-tracking
      --disable-silent-rules
      --with-openssl=#{Formula["openssl@1.1"].opt_prefix}
      --prefix=#{prefix}
      SITELISP=$prefix/share/emacs/site-lisp/urweb
    ]

    system "./configure", *args
    system "make", "install"
  end

  test do
    (testpath/"hello.ur").write <<~EOS
      fun target () = return <xml><body>
        Welcome!
      </body></xml>
      fun main () = return <xml><body>
        <a link={target ()}>Go there</a>
      </body></xml>
    EOS
    (testpath/"hello.urs").write <<~EOS
      val main : unit -> transaction page
    EOS
    (testpath/"hello.urp").write "hello"
    system "#{bin}/urweb", "hello"
    system "./hello.exe", "-h"
  end
end
