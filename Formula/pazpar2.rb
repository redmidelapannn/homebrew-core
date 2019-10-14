class Pazpar2 < Formula
  desc "Metasearching middleware webservice"
  homepage "https://www.indexdata.com/pazpar2"
  url "http://ftp.indexdata.dk/pub/pazpar2/pazpar2-1.14.0.tar.gz"
  sha256 "3b0012450c66d6932009ac0decb72436690cc939af33e2ad96c0fec85863d13d"
  revision 1

  bottle do
    cellar :any
    sha256 "5c8fc3ec2c28c7a10a551b04c5f8bf488d3818e71543b05219d3276a57da91ad" => :catalina
    sha256 "4e9286a95eea2f061126f9677d8808f90a10cf2f54167550ff60cd71135dc858" => :mojave
    sha256 "43953fefd4d01f46531d19a6a2ab39f86b0bd249a960a6e7d49fa919b35bbd2a" => :high_sierra
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
