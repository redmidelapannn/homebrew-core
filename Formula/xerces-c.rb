class XercesC < Formula
  desc "Validating XML parser"
  homepage "https://xerces.apache.org/xerces-c/"
  url "https://www.apache.org/dyn/closer.cgi?path=xerces/c/3/sources/xerces-c-3.1.4.tar.gz"
  sha256 "c98eedac4cf8a73b09366ad349cb3ef30640e7a3089d360d40a3dde93f66ecf6"

  bottle do
    cellar :any
    rebuild 1
    sha256 "da676cd1df4f3671a78ff21dd903a8e89ade9a152834c63dc9eafe3fae0c88aa" => :sierra
    sha256 "49fdbbd60440253cd11f67c0ebbb4cae8c006b9cc5b76d7962c8a4f6ee826fb4" => :el_capitan
    sha256 "6bf80f516e77b1c6661be7ce66a25577a2907c0d61671238f8ee13bd2f61fe88" => :yosemite
  end

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
    # Remove a sample program that conflicts with libmemcached
    # on case-insensitive file systems
    (bin/"MemParse").unlink
  end

  test do
    (testpath/"ducks.xml").write <<-EOS.undent
      <?xml version="1.0" encoding="iso-8859-1"?>

      <ducks>
        <person id="Red.Duck" >
          <name><family>Duck</family> <given>One</given></name>
          <email>duck@foo.com</email>
        </person>
      </ducks>
    EOS

    output = shell_output("#{bin}/SAXCount #{testpath}/ducks.xml")
    assert_match "(6 elems, 1 attrs, 0 spaces, 37 chars)", output
  end
end
