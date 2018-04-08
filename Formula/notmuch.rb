class Notmuch < Formula
  desc "Thread-based email index, search, and tagging"
  homepage "https://notmuchmail.org"
  url "https://notmuchmail.org/releases/notmuch-0.26.1.tar.gz"
  sha256 "d3f7e44f4dd0a75150b73e41737c4923ba94ea2947b9fe585f0aab591bb4a837"
  head "git://notmuchmail.org/git/notmuch"

  bottle do
    cellar :any
    rebuild 2
    sha256 "d692ec8b93e47b41c0c026c038fec104a31922269537cd99ce457084fc0f6626" => :high_sierra
    sha256 "06963165eb7e25dd9184407a0e05df1c4a18d9aad48e60504491891a99e451f9" => :sierra
    sha256 "f968ce165b5a79cbf35266b2726e8181796ed3f660cfc7d5aa160fe7f46c30ba" => :el_capitan
  end

  option "without-python@2", "Build without python2 support"

  deprecated_option "with-python3" => "with-python"
  deprecated_option "without-python" => "without-python@2"

  depends_on "doxygen" => :build
  depends_on "libgpg-error" => :build
  depends_on "pkg-config" => :build
  depends_on "sphinx-doc" => :build
  depends_on "glib"
  depends_on "gmime"
  depends_on "talloc"
  depends_on "xapian"
  depends_on "zlib"
  depends_on "python@2" => :recommended
  depends_on "emacs" => :optional
  depends_on "python" => :optional
  depends_on "ruby" => :optional

  # Fix SIP issue with python bindings
  # A more comprehensive patch has been submitted upstream
  # https://notmuchmail.org/pipermail/notmuch/2016/022631.html
  patch :DATA

  def install
    # configure runs `python -m sphinx.writers.manpage` to detect if
    # `sphinx-build` will work
    ENV.prepend_path "PYTHONPATH", Formula["sphinx-doc"].opt_libexec/"vendor/lib/python2.7/site-packages"
    ENV.prepend_path "PYTHONPATH", Formula["sphinx-doc"].opt_libexec/"lib/python2.7/site-packages"

    args = %W[--prefix=#{prefix} --mandir=#{man}]

    if build.with? "emacs"
      ENV.deparallelize # Emacs and parallel builds aren't friends
      args << "--with-emacs" << "--emacslispdir=#{elisp}" << "--emacsetcdir=#{elisp}"
    else
      args << "--without-emacs"
    end

    args << "--without-ruby" if build.without? "ruby"

    system "./configure", *args
    system "make", "V=1", "install"

    Language::Python.each_python(build) do |python, _version|
      cd "bindings/python" do
        system python, *Language::Python.setup_install_args(prefix)
      end
    end
  end

  test do
    (testpath/".notmuch-config").write "[database]\npath=#{testpath}/Mail"
    (testpath/"Mail").mkpath
    assert_match "0 total", shell_output("#{bin}/notmuch new")
  end
end

__END__
diff --git a/bindings/python/notmuch/globals.py b/bindings/python/notmuch/globals.py
index b1eec2c..bce5190 100644
--- a/bindings/python/notmuch/globals.py
+++ b/bindings/python/notmuch/globals.py
@@ -25,7 +25,7 @@ from notmuch.version import SOVERSION
 try:
     from os import uname
     if uname()[0] == 'Darwin':
-        nmlib = CDLL("libnotmuch.{0:s}.dylib".format(SOVERSION))
+        nmlib = CDLL("HOMEBREW_PREFIX/lib/libnotmuch.{0:s}.dylib".format(SOVERSION))
     else:
         nmlib = CDLL("libnotmuch.so.{0:s}".format(SOVERSION))
 except:
