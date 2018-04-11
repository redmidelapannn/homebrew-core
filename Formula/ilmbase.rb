class Ilmbase < Formula
  desc "OpenEXR ILM Base libraries (high dynamic-range image file format)"
  homepage "https://www.openexr.com/"
  url "https://download.savannah.nongnu.org/releases/openexr/ilmbase-2.2.1.tar.gz"
  sha256 "cac206e63be68136ef556c2b555df659f45098c159ce24804e9d5e9e0286609e"

  bottle do
    cellar :any
    sha256 "c498613d41a445ee239370fb9bc893f1c37f7a4a7e4b188b9b1ed9d2c02dfcbb" => :high_sierra
    sha256 "d56380c365b293949e3562baa456c584296b70bcc7118c7389c4ce978c5db91f" => :sierra
    sha256 "44399ffee5a2a30207586e0ab336f2be0a34c7931d383937345bfa66e6f513c8" => :el_capitan
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
