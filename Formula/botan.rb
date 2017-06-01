class Botan < Formula
  desc "Cryptographic algorithms and formats library in C++"
  homepage "https://botan.randombit.net/"
  url "https://botan.randombit.net/releases/Botan-2.1.0.tgz"
  sha256 "460f2d7205aed113f898df4947b1f66ccf8d080eec7dac229ef0b754c9ad6294"
  head "https://github.com/randombit/botan.git"

  bottle do
    rebuild 1
    sha256 "417aab68dfd42eff212fc64b4f6f95b206b2092cb2cc83a38b6c89e6eddaee49" => :sierra
    sha256 "53cb31f3499976f12398e256202acd2dde4ec7ad95b9f9a476d04bd282e51508" => :el_capitan
    sha256 "c946f6f4915d9aed7edce667b4cfedafe8418c4d9fa9e343106b27b45f7c13c1" => :yosemite
  end

  option "with-debug", "Enable debug build of Botan"

  deprecated_option "enable-debug" => "with-debug"

  depends_on "pkg-config" => :build
  depends_on "openssl"

  needs :cxx11

  def install
    ENV.cxx11

    args = %W[
      --prefix=#{prefix}
      --docdir=share/doc
      --cpu=#{MacOS.preferred_arch}
      --cc=#{ENV.compiler}
      --os=darwin
      --with-openssl
      --with-zlib
      --with-bzip2
    ]

    args << "--enable-debug" if build.with? "debug"

    cd "botan--git" if build.head?
    system "./configure.py", *args
    # A hack to force them use our CFLAGS. MACH_OPT is empty in the Makefile
    # but used for each call to cc/ld.
    system "make", "install", "MACH_OPT=#{ENV.cflags}"
  end

  test do
    (testpath/"test.txt").write "Homebrew"
    (testpath/"testout.txt").write Utils.popen_read("#{bin}/botan base64_enc test.txt")
    assert_match "Homebrew", shell_output("#{bin}/botan base64_dec testout.txt")
  end
end
