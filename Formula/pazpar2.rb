class Pazpar2 < Formula
  desc "Metasearching middleware webservice"
  homepage "https://www.indexdata.com/pazpar2"
  url "http://ftp.indexdata.dk/pub/pazpar2/pazpar2-1.13.1.tar.gz"
  sha256 "d3cdeff52914a82c4d815e4570f6aab0e14586754377b5d2b9cffdcbcb1ccc29"
  revision 1

  bottle do
    cellar :any
    sha256 "4e5d8a3e89b2c6c60047481baa9821c030473d33355f025f936ab79b6ef6eea7" => :mojave
    sha256 "3833bff5a7de29ebc97d4b18e7c311cae100e2ddb9a1ede39f6165198f104d2e" => :high_sierra
    sha256 "5c29945513d59e563fc88cd6a0ec258a4b1fe9e0c983e8228eeb10de838097b4" => :sierra
  end

  head do
    url "https://github.com/indexdata/pazpar2.git"
    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "pkg-config" => :build
  depends_on "icu4c"
  depends_on "yaz"

  def install
    system "./buildconf.sh" if build.head?
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test-config.xml").write <<~EOS
      <?xml version="1.0" encoding="UTF-8"?>
      <pazpar2 xmlns="http://www.indexdata.com/pazpar2/1.0">
        <threads number="2"/>
        <server>
          <listen port="8004"/>
        </server>
      </pazpar2>
    EOS

    system "#{sbin}/pazpar2", "-t", "-f", "#{testpath}/test-config.xml"
  end
end
