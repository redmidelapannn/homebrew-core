class Sdhash < Formula
  desc "Tool for correlating binary blobs of data"
  homepage "http://roussev.net/sdhash/sdhash.html"
  url "http://roussev.net/sdhash/releases/packages/sdhash-3.1.tar.gz"
  sha256 "b991d38533d02ae56e0c7aeb230f844e45a39f2867f70fab30002cfa34ba449c"
  revision 1

  bottle do
    cellar :any
    rebuild 1
    sha256 "def41c78c619370499a5de827498238a3e2bb42a500b5423f4288e9f8420413b" => :mojave
    sha256 "8ccb9b335b7bd04ecf3bb4f72066a1695c0c95243b2ba28ba77f55eb33f05374" => :high_sierra
    sha256 "da3db1c0fe5a6aa37ac6d87ad1f3f10afcbe613904af5acf19781b9d8ad03bce" => :sierra
  end

  depends_on "openssl"

  def install
    inreplace "Makefile" do |s|
      # Remove space between -L and the path (reported upstream)
      s.change_make_var! "LDFLAGS",
                         "-L. -L./external/stage/lib -lboost_regex -lboost_system -lboost_filesystem " \
                         "-lboost_program_options -lc -lm -lcrypto -lboost_thread -lpthread"
    end
    system "make", "boost"
    system "make", "stream"
    bin.install "sdhash"
    man1.install Dir["man/*.1"]
  end

  test do
    system "#{bin}/sdhash"
  end
end
