class SwiProlog < Formula
  desc "ISO/Edinburgh-style Prolog interpreter"
  homepage "http://www.swi-prolog.org/"
  url "http://www.swi-prolog.org/download/stable/src/swipl-7.2.3.tar.gz"
  sha256 "43657d51b7c5887bc2d2bced50a9822b86a08a6841399b8e76ee877f51d646b5"

  bottle do
    revision 1
    sha256 "512f98c2da6bd2d25736d04f787e8709632cd98909414446f2794f3d7d4c324c" => :el_capitan
    sha256 "1d6e3d0015f6418cc6515bbe8b0903fa8cd9c4c70639bf5d0e8e0b916d5c8651" => :yosemite
    sha256 "083d3cfdb2a58de4d9a759728f90301f83e5ed2bd70c4854baaa887806e7b6ab" => :mavericks
  end

  devel do
    url "http://www.swi-prolog.org/download/devel/src/swipl-7.3.24.tar.gz"
    sha256 "4fd337d0817373c7c8d59cce5324e068be316d28dc3e81877075cd51168dd7cd"
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

  fails_with :llvm do
    build 2335
    cause "Exported procedure chr_translate:chr_translate_line_info/3 is not defined"
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
