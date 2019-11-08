class Pdnsrec < Formula
  desc "Non-authoritative/recursing DNS server"
  homepage "https://www.powerdns.com/recursor.html"
  url "https://downloads.powerdns.com/releases/pdns-recursor-4.2.0.tar.bz2"
  sha256 "f03c72c1816fdcc645cc539d8c16721d2ec294feac9b5179e78c3db311b7c2c2"
  revision 1

  bottle do
    rebuild 1
    sha256 "213a481572b1eaa7698aad8b4f4ed33bdf9e69842806a8af6176d6de7f09b628" => :catalina
    sha256 "cd4b5d0bd659019d1db24182b181f146dae55033e26b4e954cf2322e7103a899" => :mojave
    sha256 "21df41f7277e20fedd3869dea234b869dcf96703f2c4185489f7e697216ad433" => :high_sierra
  end

  depends_on "pkg-config" => :build
  depends_on "boost"
  depends_on "gcc" if DevelopmentTools.clang_build_version == 600
  depends_on "lua"
  depends_on "openssl@1.1"

  def install
    ENV.cxx11

    args = %W[
      --prefix=#{prefix}
      --sysconfdir=#{etc}/powerdns
      --disable-silent-rules
      --with-boost=#{Formula["boost"].opt_prefix}
      --with-libcrypto=#{Formula["openssl@1.1"].opt_prefix}
      --with-lua
      --without-net-snmp
    ]

    system "./configure", *args
    system "make", "install"
  end

  test do
    output = shell_output("#{sbin}/pdns_recursor --version 2>&1")
    assert_match "PowerDNS Recursor #{version}", output
  end
end
