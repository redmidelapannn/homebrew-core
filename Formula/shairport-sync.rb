class ShairportSync < Formula
  desc "AirTunes emulator that adds multi-room capability"
  homepage "https://github.com/mikebrady/shairport-sync"
  url "https://github.com/mikebrady/shairport-sync/archive/3.3.tar.gz"
  sha256 "3e621c8de4a0dcdfd39442ece9841ab14bc2093d724ae84c30154a9aeb5d1329"
  head "https://github.com/mikebrady/shairport-sync.git", :branch => "development"

  bottle do
    sha256 "b6e67353de20b8a3d301a25f7dad67a772d7047360a35d3d10d90940d4c33874" => :mojave
    sha256 "760f2a7d72a057d20f569035f05e28f5e04f1e1fa1f9f03ace207d0d1bd87144" => :high_sierra
    sha256 "10db1975e96bb32e2b06c86326ee90290516e6de19c57991615eb6c9c9ed7ed1" => :sierra
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "pkg-config" => :build
  depends_on "libao"
  depends_on "libconfig"
  depends_on "libdaemon"
  depends_on "libsoxr"
  depends_on "openssl"
  depends_on "popt"

  def install
    system "autoreconf", "-fvi"
    args = %W[
      --with-os=darwin
      --with-ssl=openssl
      --with-dns_sd
      --with-ao
      --with-stdout
      --with-pipe
      --with-soxr
      --with-metadata
      --with-piddir=#{var}/run
      --sysconfdir=#{etc}/shairport-sync
      --prefix=#{prefix}
    ]
    system "./configure", *args
    system "make", "install"
  end

  def post_install
    (var/"run").mkpath
  end

  test do
    output = shell_output("#{bin}/shairport-sync -V", 1)
    assert_match "OpenSSL-ao-stdout-pipe-soxr-metadata", output
  end
end
