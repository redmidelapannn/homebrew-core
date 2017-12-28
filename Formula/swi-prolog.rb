class SwiProlog < Formula
  desc "ISO/Edinburgh-style Prolog interpreter"
  homepage "http://www.swi-prolog.org/"
  url "http://www.swi-prolog.org/download/stable/src/swipl-7.6.3.tar.gz"
  sha256 "9c0be513dc98e6ca420d109f7a455a6593840682cf1b0e21876d1e71e7f35d39"

  bottle do
    rebuild 1
    sha256 "abc9db16d7b52420d05f66878a353501a2b7ed18c244d520de8d809629dfc407" => :high_sierra
    sha256 "7b2228524149436960dc746696a11ab6a9911504b5ee12010b7f8f38dd4cc765" => :sierra
    sha256 "e971dbb4e08c984fed1c1c9ee5554e779d32debe443e2592e6822645a6073699" => :el_capitan
  end

  devel do
    url "http://www.swi-prolog.org/download/devel/src/swipl-7.7.7.tar.gz"
    sha256 "0b0ca7832fcfebbf8b9d707aeccb13c926dc18ca7dd68dec206fb9868a75a232"
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
    if build.with? "libarchive"
      ENV["ARPREFIX"] = Formula["libarchive"].opt_prefix
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
    (testpath/"test.pl").write <<~EOS
      test :-
          write('Homebrew').
    EOS
    assert_equal "Homebrew", shell_output("#{bin}/swipl -s #{testpath}/test.pl -g test -t halt")
  end
end
