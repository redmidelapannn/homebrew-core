class SwiProlog < Formula
  desc "ISO/Edinburgh-style Prolog interpreter"
  homepage "http://www.swi-prolog.org/"
  url "http://www.swi-prolog.org/download/stable/src/swipl-7.4.2.tar.gz"
  sha256 "7f17257da334bc1e7a35e9cf5cb8fca01d82f1ea406c7ace76e9062af8f0df8b"

  bottle do
    rebuild 1
    sha256 "4c091f84a2d3905242deafb664105612352068f47128fd07fa15e9f9cecb3cf8" => :high_sierra
    sha256 "993f449b60cce0682702118cb2bd1a3bd5284d19c075a3d34f3d850c224075b9" => :sierra
    sha256 "348c75bfa6e75c6021d6131454c5f83dfa0b4ace97005cbf37a87b5ea1ed881e" => :el_capitan
  end

  devel do
    url "http://www.swi-prolog.org/download/devel/src/swipl-7.7.1.tar.gz"
    sha256 "fda2c8b6b606ff199ea8a6f019008aa8272b7c349cb9312ccd5944153509503a"
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
      if build.head?
        cs = "configure.ac"
      elsif build.devel?
        cs = "configure"
      else
        cs = "configure.in"
      end

      inreplace "packages/archive/#{cs}",
                "/opt/local",
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
