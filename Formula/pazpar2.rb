class Pazpar2 < Formula
  desc "Metasearching middleware webservice"
  homepage "https://www.indexdata.com/pazpar2"
  url "http://ftp.indexdata.dk/pub/pazpar2/pazpar2-1.12.9.tar.gz"
  sha256 "86142e1275546e95395a0b82bfc6d4e5b24b86183ec1a59f843033c1cbdd815d"
  revision 1

  bottle do
    cellar :any
    sha256 "e466e3be386ac0bb4455541ff0d77d6cb59a6398697c4f3b86b09a2a3e70134c" => :sierra
    sha256 "63b47991c544973237be945c8358dd26f8aa37ebf21d63fa18fecdf4a22d7d75" => :el_capitan
    sha256 "5bb0e90a8c09f0ac4206902a158b2deb3861138b0f6b778a67f2516905f78f54" => :yosemite
  end

  head do
    url "https://github.com/indexdata/pazpar2.git"
    depends_on "automake" => :build
    depends_on "autoconf" => :build
    depends_on "libtool" => :build
  end

  depends_on "pkg-config" => :build
  depends_on "icu4c" => :recommended
  depends_on "yaz"

  def install
    system "./buildconf.sh" if build.head?
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test-config.xml").write <<-EOS.undent
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
