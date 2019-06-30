class Maxima < Formula
  desc "Computer algebra system"
  homepage "https://maxima.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/maxima/Maxima-source/5.43.0-source/maxima-5.43.0.tar.gz"
  sha256 "dcfda54511035276fd074ac736e97d41905171e43a5802bb820914c3c885ca77"
  revision 1

  bottle do
    cellar :any_skip_relocation
    sha256 "cd194c3a36cec930f68c85ea94322506154d435dbd67d347b098c77225f4001d" => :mojave
    sha256 "0c1108a12de5097b7f766acc4cf16e571ed0c7fcd52d4ca87d7b2a5255e422f3" => :high_sierra
    sha256 "8958ace1eba549328d3295eb57228b82f456a3ef074c8be106940ccfed82d0d5" => :sierra
  end

  depends_on "sbcl" => :build
  depends_on "gettext"
  depends_on "gnuplot"
  depends_on "rlwrap"

  def install
    ENV["LANG"] = "C" # per build instructions
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--enable-gettext",
                          "--enable-sbcl",
                          "--enable-sbcl-exec",
                          "--with-emacs-prefix=#{share}/emacs/site-lisp/#{name}",
                          "--with-sbcl=#{Formula["sbcl"].opt_bin}/sbcl"
    system "make"
    system "make", "install"
  end

  test do
    system "#{bin}/maxima", "--batch-string=run_testsuite(); quit();"
  end
end
