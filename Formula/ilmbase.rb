class Ilmbase < Formula
  desc "OpenEXR ILM Base libraries (high dynamic-range image file format)"
  homepage "http://www.openexr.com/"
  url "https://savannah.nongnu.org/download/openexr/ilmbase-2.2.0.tar.gz"
  mirror "https://mirrorservice.org/sites/download.savannah.gnu.org/releases/openexr/ilmbase-2.2.0.tar.gz"
  sha256 "ecf815b60695555c1fbc73679e84c7c9902f4e8faa6e8000d2f905b8b86cedc7"

  bottle do
    rebuild 3
    sha256 "aed8fd2f8162ba76521beb86cceb3a794c4bc80601d9518652ba700fe1c0b510" => :sierra
    sha256 "d7c8b45d205fe55b4581babbc53c0c618ad5057f1a324caaba0818bf0f10cef3" => :el_capitan
    sha256 "2bdd1cd8da3f1676211bae04fbd6efdaa0141ce6044e7bb2a98956c73b042657" => :yosemite
  end

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
    pkgshare.install %w[Half HalfTest Iex IexMath IexTest IlmThread Imath ImathTest]
  end

  test do
    cd pkgshare/"IexTest" do
      system ENV.cxx, "-I#{include}/OpenEXR", "-I./", "-c",
             "testBaseExc.cpp", "-o", testpath/"test"
    end
  end
end
