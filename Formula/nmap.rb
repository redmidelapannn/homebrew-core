class Nmap < Formula
  desc "Port scanning utility for large networks"
  homepage "https://nmap.org/"
  url "https://nmap.org/dist/nmap-7.12.tar.bz2"
  sha256 "63df082a87c95a189865d37304357405160fc6333addcf5b84204c95e0539b04"
  head "https://guest:@svn.nmap.org/nmap/", :using => :svn

  bottle do
    revision 1
    sha256 "967e18be1d96c76380ba094e7036504203433c514b38ce129fc81ba942aa1018" => :el_capitan
    sha256 "ac73476ff00df9716de5e9ac22c6718c0ccad2322059e3a6185ca7d74887641c" => :yosemite
    sha256 "d838ae4e257921697fe6a1659884013deca89ba3726d3468708e07df94228fab" => :mavericks
  end

  option "with-pygtk", "Build Zenmap GUI"

  depends_on "openssl"
  depends_on "pygtk" => :optional

  conflicts_with "ndiff", :because => "both install `ndiff` binaries"

  fails_with :llvm do
    build 2334
  end

  def install
    ENV.deparallelize

    args = %W[
      --prefix=#{prefix}
      --with-libpcre=included
      --with-liblua=included
      --with-openssl=#{Formula["openssl"].opt_prefix}
      --without-nmap-update
      --disable-universal
    ]

    args << "--without-zenmap" if build.without? "pygtk"

    system "./configure", *args
    system "make" # separate steps required otherwise the build fails
    system "make", "install"
  end

  test do
    system "#{bin}/nmap", "-p80,443", "google.com"
  end
end
