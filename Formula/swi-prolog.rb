class SwiProlog < Formula
  desc "ISO/Edinburgh-style Prolog interpreter"
  homepage "http://www.swi-prolog.org/"
  url "http://www.swi-prolog.org/download/stable/src/swipl-7.4.2.tar.gz"
  sha256 "7f17257da334bc1e7a35e9cf5cb8fca01d82f1ea406c7ace76e9062af8f0df8b"

  bottle do
    rebuild 1
    sha256 "5c1015e4bc2763036e1a83548c95df4beb791280d7e091ec5c6ca6c3c53d8410" => :sierra
    sha256 "67c6cce41a6ed6117877bf767190b329baa1df7921c8e167d036e32e4d4f0626" => :el_capitan
    sha256 "e3b5269eb189a954b76eae790509acdc711a34f19b72659585941abc5c249fe1" => :yosemite
  end

  devel do
    url "http://www.swi-prolog.org/download/devel/src/swipl-7.5.10.tar.gz"
    sha256 "365941d9863a22949b42a2e0494f4209e96429e2c93f93b369fc9f4512525ddf"
  end

  head do
    url "https://github.com/SWI-Prolog/swipl-devel.git"

    depends_on "autoconf" => :build
  end

  option "with-lite", "Disable all packages"
  option "with-jpl", "Enable JPL (Java Prolog Bridge)"
  option "with-xpce", "Enable XPCE (Prolog Native GUI Library)"

  deprecated_option "lite" => "with-lite"

  depends_on "pkg-config" => :build
  depends_on "readline"
  depends_on "gmp"
  depends_on "openssl"
  depends_on "libarchive" => :optional

  if build.with? "xpce"
    depends_on :x11
    depends_on "jpeg"
  end

  def install
    # The archive package hard-codes a check for MacPort libarchive
    # Replace this with a check for Homebrew's libarchive, or nowhere
    if build.with? "libarchive"
      inreplace "packages/archive/configure.in", "/opt/local",
                                                 Formula["libarchive"].opt_prefix
    else
      ENV.append "DISABLE_PKGS", "archive"
    end

    args = ["--prefix=#{libexec}", "--mandir=#{man}"]
    ENV.append "DISABLE_PKGS", "jpl" if build.without? "jpl"
    ENV.append "DISABLE_PKGS", "xpce" if build.without? "xpce"

    # SWI-Prolog's Makefiles don't add CPPFLAGS to the compile command, but do
    # include CIFLAGS. Setting it here. Also, they clobber CFLAGS, so including
    # the Homebrew-generated CFLAGS into COFLAGS here.
    ENV["CIFLAGS"] = ENV.cppflags
    ENV["COFLAGS"] = ENV.cflags

    # Build the packages unless --with-lite option specified
    args << "--with-world" if build.without? "lite"

    # './prepare' prompts the user to build documentation
    # (which requires other modules). '3' is the option
    # to ignore documentation.
    system "echo 3 | ./prepare" if build.head?
    system "./configure", *args
    system "make"
    system "make", "install"

    bin.write_exec_script Dir["#{libexec}/bin/*"]
  end

  test do
    (testpath/"test.pl").write <<-EOS.undent
      test :-
          write('Homebrew').
    EOS
    assert_equal "Homebrew", shell_output("#{bin}/swipl -s #{testpath}/test.pl -g test -t halt")
  end
end
