class GnuApl < Formula
  desc "GNU implementation of the programming language APL"
  homepage "https://www.gnu.org/software/apl/"
  url "https://ftp.gnu.org/gnu/apl/apl-1.7.tar.gz"
  mirror "https://ftpmirror.gnu.org/apl/apl-1.7.tar.gz"
  sha256 "8ff6e28256d7a3cdfa9dc6025e3905312310b27a43645ef5d617fd4a5b43b81f"

  bottle do
    rebuild 2
    sha256 "4b5c87fa40c95628807704e2023e3be42589add9e9f850ca6c1859b553003383" => :high_sierra
    sha256 "3ac1daf24f968de9c1dc19c5501524627067da30550c31f455838f9c9e1e7961" => :sierra
    sha256 "105d6dac66809e5cae63eda1d27bfe390ca70702185b083f0fc0c88faefff2d4" => :el_capitan
  end

  head do
    url "https://svn.savannah.gnu.org/svn/apl/trunk"

    depends_on "automake" => :build
    depends_on "autoconf" => :build
    depends_on "libtool" => :build
  end

  # GNU Readline is required; libedit won't work.
  depends_on "readline"
  depends_on :macos => :mavericks
  depends_on "libpq" => :optional

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
    (testpath/"hello.apl").write <<-EOS.undent
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
