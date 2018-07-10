class Kore < Formula
  desc "Web application framework for writing web APIs in C"
  homepage "https://kore.io/"
  url "https://kore.io/releases/kore-3.0.0.tar.gz"
  sha256 "aa6822f70a8a839fc881c8684a0289e082ec34471eda3bbca9a1ca53d2c5164a"
  head "https://github.com/jorisvink/kore.git"

  bottle do
    sha256 "1d0d3e6a3264d9ac5fa341f5ee95d9f24ebb58a0ecb6cfcfaaf67ea4d27b1466" => :high_sierra
    sha256 "df4df7731991c80ca7778f13fe56e89334bed3c362e47a6fe42b8bbfe38c4a46" => :sierra
  end

  # src/pool.c:151:6: error: use of undeclared identifier 'MAP_ANONYMOUS'
  # Reported 4 Aug 2016: https://github.com/jorisvink/kore/issues/140
  depends_on :macos => :yosemite

  depends_on "openssl"
  depends_on "postgresql" => :optional

  def install
    # Ensure make finds our OpenSSL when Homebrew isn't in /usr/local.
    # Current Makefile hardcodes paths for default MacPorts/Homebrew.
    ENV.prepend "CFLAGS", "-I#{Formula["openssl"].opt_include}"
    ENV.prepend "LDFLAGS", "-L#{Formula["openssl"].opt_lib}"
    # Also hardcoded paths in src/cli.c at compile.
    inreplace "src/cli.c", "/usr/local/opt/openssl/include",
                            Formula["openssl"].opt_include

    args = []

    args << "PGSQL=1" if build.with? "postgresql"

    system "make", "PREFIX=#{prefix}", "TASKS=1", *args
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    system bin/"kore", "create", "test"
    cd "test" do
      system bin/"kore", "build"
      system bin/"kore", "clean"
    end
  end
end
