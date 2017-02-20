class Nmap < Formula
  desc "Port scanning utility for large networks"
  homepage "https://nmap.org/"
  url "https://nmap.org/dist/nmap-7.40.tar.bz2"
  sha256 "9e14665fffd054554d129d62c13ad95a7b5c7a046daa2290501909e65f4d3188"
  head "https://svn.nmap.org/nmap/"

  bottle do
    rebuild 1
    sha256 "af84368be02f61678e15c4fb28dd99f8d91b16dc13154ed2b5f7081d92f3fea6" => :sierra
    sha256 "78e7d5b212a72fc5070192ee5327f9d70523ad27937af856cc90730d055ee495" => :el_capitan
    sha256 "23c98385d613a5fa0c485c6d98b021c722d6fe571a3c61bef084097f69c527c3" => :yosemite
  end

  option "with-pygtk", "Build Zenmap GUI"

  depends_on "openssl"
  depends_on "pygtk" => :optional

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
