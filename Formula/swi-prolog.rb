class SwiProlog < Formula
  desc "ISO/Edinburgh-style Prolog interpreter"
  homepage "http://www.swi-prolog.org/"
  url "http://www.swi-prolog.org/download/stable/src/swipl-7.6.4.tar.gz"
  sha256 "2d3d7aabd6d99a02dcc2da5d7604e3500329e541c6f857edc5aa06a3b1267891"

  bottle do
    rebuild 1
    sha256 "fdb301ad65d2ad59bcf7a906058876b58b9d706e1ab4e1e8c3eb537a7896b3df" => :mojave
    sha256 "90e135889890991b007e462099edaae7b2f751d9f53165dedde7eb9395fe957e" => :high_sierra
    sha256 "6d2820b295b4cd5e5e9f5bbeafe72822c8e34ac98090ab8d81209a2d9f2dddf2" => :sierra
  end

  head do
    url "https://github.com/SWI-Prolog/swipl-devel.git"

    depends_on "cmake" => :build
  end

  option "with-jpl",     "Enable JPL (Java Prolog Bridge)"
  option "without-xpce", "Disable XPCE (Prolog Native GUI Library)"

  depends_on "ossp-uuid"
  depends_on "readline"
  depends_on "gmp" => :recommended
  depends_on "libarchive" => :recommended
  depends_on "openssl" => :recommended
  depends_on "pcre" => :recommended
  depends_on "berkeley-db" => :optional
  depends_on "unixodbc" => :optional

  unless build.without? "xpce"
    depends_on :x11
    depends_on "jpeg"
  end

  def install
    if build.head?
      swi_options = []

      swi_options.push("-DSWIPL_PACKAGES_X=OFF")    if build.without? "xpce"
      swi_options.push("-DSWIPL_PACKAGES_JAVA=OFF") if build.without? "jpl"

      system "cmake", ".", *std_cmake_args, *swi_options
    else
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

      system "./configure", *args
    end

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
