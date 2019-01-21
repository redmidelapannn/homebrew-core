class Nmap < Formula
  desc "Port scanning utility for large networks"
  homepage "https://nmap.org/"
  url "https://nmap.org/dist/nmap-7.70.tar.bz2"
  sha256 "847b068955f792f4cc247593aca6dc3dc4aae12976169873247488de147a6e18"
  head "https://svn.nmap.org/nmap/"

  bottle do
    rebuild 1
    sha256 "b90ab9ae74530d87292cbd89a67572719a1650daad1f3c279308986332c39bf6" => :mojave
    sha256 "2f4245aa40ab11d77e3ef9cf7496465258aa1bc599cc8bc77f4986c38cbce4d2" => :high_sierra
    sha256 "91f5fd86e43316ca9306ece64978a62d7c1ce76bf5e0d5e7850290b099d79cd3" => :sierra
  end

  depends_on "openssl"

  conflicts_with "ndiff", :because => "both install `ndiff` binaries"

  def install
    ENV.deparallelize

    args = %W[
      --prefix=#{prefix}
      --with-libpcre=included
      --with-liblua=included
      --with-openssl=#{Formula["openssl"].opt_prefix}
      --without-nmap-update
      --disable-universal
      --without-zenmap
    ]

    system "./configure", *args
    system "make" # separate steps required otherwise the build fails
    system "make", "install"

    rm_f Dir[bin/"uninstall_*"] # Users should use brew uninstall.
  end

  test do
    system "#{bin}/nmap", "-p80,443", "google.com"
  end
end
