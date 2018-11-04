class SwiProlog < Formula
  desc "ISO/Edinburgh-style Prolog interpreter"
  homepage "http://www.swi-prolog.org/"
  url "http://www.swi-prolog.org/download/stable/src/swipl-7.6.4.tar.gz"
  sha256 "2d3d7aabd6d99a02dcc2da5d7604e3500329e541c6f857edc5aa06a3b1267891"

  bottle do
    rebuild 1
    sha256 "0ca7d11c9bd7a55329e6858c428f671b3d35e5d2e8c28bfe639a87c0a8af5099" => :mojave
    sha256 "7e9a96b62a531e3787a7ea318e71241b05292040053cee427264d65f8ae9f32e" => :high_sierra
    sha256 "00f37afa2e50d4b214de7a46ad2ec166a00fe2974c3745ef262f8f3e802e7bd4" => :sierra
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
