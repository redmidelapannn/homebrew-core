class Ilmbase < Formula
  desc "OpenEXR ILM Base libraries (high dynamic-range image file format)"
  homepage "https://www.openexr.com/"
  url "https://savannah.nongnu.org/download/openexr/ilmbase-2.2.0.tar.gz"
  mirror "https://mirrorservice.org/sites/download.savannah.gnu.org/releases/openexr/ilmbase-2.2.0.tar.gz"
  sha256 "ecf815b60695555c1fbc73679e84c7c9902f4e8faa6e8000d2f905b8b86cedc7"

  bottle do
    cellar :any
    rebuild 4
    sha256 "abd015b61c2fee5467faabb2d162269384452304aaa6665f29083779409d1355" => :high_sierra
    sha256 "8c8073dc1c5ae71091910ef2f90538e21050e08d6fac8e9e0b92f423ddeec36d" => :sierra
    sha256 "b4668250482d810e23c46fbdcff7233400e3a420746eb0daab105ea65d04da90" => :el_capitan
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
