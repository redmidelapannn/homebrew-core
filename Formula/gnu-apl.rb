class GnuApl < Formula
  desc "GNU implementation of the programming language APL"
  homepage "https://www.gnu.org/software/apl/"
  url "https://ftp.gnu.org/gnu/apl/apl-1.7.tar.gz"
  mirror "https://ftpmirror.gnu.org/apl/apl-1.7.tar.gz"
  sha256 "8ff6e28256d7a3cdfa9dc6025e3905312310b27a43645ef5d617fd4a5b43b81f"

  bottle do
    rebuild 2
    sha256 "415b807c48fc2733e58caf67485c5314326c49f9310053b7b5778c376c5ca7af" => :mojave
    sha256 "6f61dbd3a46b776fcb4372e294f30451f6ad99fa63bb0e6f603260181ce2a83a" => :sierra
  end

  head do
    url "https://svn.savannah.gnu.org/svn/apl/trunk"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "readline" # GNU Readline is required, libedit won't work

  def install
    # Work around "error: no member named 'signbit' in the global namespace"
    # encountered when trying to detect boost regex in configure
    ENV.delete("SDKROOT") if DevelopmentTools.clang_build_version >= 900

    system "autoreconf", "-fiv" if build.head?
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"hello.apl").write <<~EOS
      'Hello world'
      )OFF
    EOS

    pid = fork do
      exec "#{bin}/APserver"
    end
    sleep 4

    begin
      assert_match "Hello world", shell_output("#{bin}/apl -s -f hello.apl")
    ensure
      Process.kill("SIGINT", pid)
      Process.wait(pid)
    end
  end
end
