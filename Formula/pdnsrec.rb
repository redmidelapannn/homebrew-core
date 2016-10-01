class Pdnsrec < Formula
  desc "Non-authoritative/recursing DNS server"
  homepage "https://www.powerdns.com/recursor.html"
  url "https://downloads.powerdns.com/releases/pdns-recursor-4.0.3.tar.bz2"
  sha256 "ae9813a64d13d9ebe4b44e89e8e4e44fc438693b6ce4c3a98e4cab1af22d9627"
  revision 1

  bottle do
    sha256 "693854c8cf3c21d4aab4b26a4f30d26740af07c850df9c00a619d2ef0bc48f5b" => :sierra
    sha256 "23dfeb3a68c265a0323c0e1ac758361f54af5cb48fb4a7a59e277298398b2cdc" => :el_capitan
    sha256 "55198f786fc9a334e0a089c1ed51feb56276fd9a482d1490b5d2268ece42e0d1" => :yosemite
  end

  depends_on "pkg-config" => :build
  depends_on "boost@1.61"
  depends_on "openssl"
  depends_on "lua"
  depends_on "gcc" if DevelopmentTools.clang_build_version <= 600

  needs :cxx11

  fails_with :clang do
    build 600
    cause "incomplete C++11 support"
  end

  # Remove for > 4.0.3
  # Upstream commit "rec: Fix Lua-enabled compilation on OS X and FreeBSD"
  patch :p2 do
    url "https://github.com/PowerDNS/pdns/commit/546d1fb.patch"
    sha256 "9a7711596aebaf3eceaf8abcf723df12aa9c22583e6bb177b4eb0f90c8bb2ec3"
  end

  def install
    ENV.cxx11

    # Remove for > 4.0.3; using inreplace avoids Autotools dependencies
    # Upstream PR "Fall back to SystemV ucontexts on boost >= 1.61"
    # See https://github.com/PowerDNS/pdns/commit/fbf562c
    inreplace "configure", "boost/context/detail/fcontext.hpp",
                           "boost/context/fcontext.hpp"

    args = %W[
      --prefix=#{prefix}
      --sysconfdir=#{etc}/powerdns
      --disable-silent-rules
      --with-boost=#{Formula["boost"].opt_prefix}
      --with-openssl=#{Formula["openssl"].opt_prefix}
      --with-lua
    ]

    system "./configure", *args
    system "make", "install"
  end

  test do
    output = shell_output("#{sbin}/pdns_recursor --version 2>&1")
    assert_match "PowerDNS Recursor #{version}", output
  end
end
