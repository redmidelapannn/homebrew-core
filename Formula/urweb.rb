class Urweb < Formula
  desc "Ur/Web programming language"
  homepage "http://www.impredicative.com/ur/"
  url "https://github.com/urweb/urweb/releases/download/20190217/urweb-20190217.tar.gz"
  sha256 "da24e093369a14ae738dfb08d83fcba083ce07360023f6f55734f0e335e880b2"

  bottle do
    sha256 "602d58273a9177d2d084d7e09db9c24e244b950d0f3bf84cb5b6205aded31089" => :mojave
    sha256 "2b62203872037829b5445e3ffddd6b204893b6a6b9661ce318e3326e35aebe63" => :high_sierra
    sha256 "85eff6aacd5ca6a50bb3160987594b33469fb128d67202d703986aefedc12d96" => :sierra
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "mlton" => :build
  depends_on "gmp"
  depends_on "icu4c"
  depends_on "openssl"

  def install
    args = %W[
      --disable-debug
      --disable-dependency-tracking
      --disable-silent-rules
      --with-openssl=#{Formula["openssl"].opt_prefix}
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
