class XercesC < Formula
  desc "Validating XML parser"
  homepage "https://xerces.apache.org/xerces-c/"
  url "https://www.apache.org/dyn/closer.cgi?path=xerces/c/3/sources/xerces-c-3.2.1.tar.gz"
  sha256 "6dd4602b8844a9e1ab206e0270935d0c9b5f9d88771026e7f350e429bd2d04a0"

  bottle do
    cellar :any
    rebuild 1
    sha256 "0c5f596ced40bedcc87125f625dc52323c750f308b09f3ffdd826d923d354756" => :high_sierra
    sha256 "66d9d1d8bdd2b19fbef97c386a77238147126784267a6106f4e9b769ce8ba3ec" => :sierra
    sha256 "610958469f6c1d5addc139aad72f7064c92fef7e5711e7b1ce5664e962e8a8bb" => :el_capitan
  end

  depends_on "cmake" => :build

  def install
    mkdir "build" do
      system "cmake", "..", "-Dxmlch-type=uint16_t", *std_cmake_args
      system "make"
      system "ctest", "-V"
      system "make", "install"
    end
    # Remove a sample program that conflicts with libmemcached
    # on case-insensitive file systems
    (bin/"MemParse").unlink
  end

  test do
    (testpath/"ducks.xml").write <<~EOS
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
