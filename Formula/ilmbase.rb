class Ilmbase < Formula
  desc "OpenEXR ILM Base libraries (high dynamic-range image file format)"
  homepage "http://www.openexr.com/"
  url "https://github.com/openexr/openexr/releases/download/v2.3.0/ilmbase-2.3.0.tar.gz"
  sha256 "456978d1a978a5f823c7c675f3f36b0ae14dba36638aeaa3c4b0e784f12a3862"

  bottle do
    cellar :any
    sha256 "97d55b4146dcddc4655edae59a3e8826624e39884514dab855a05961cb0df040" => :mojave
    sha256 "33a9f0628790eff45c506f41932c62597d5862ed71634a864bfb57f84ea5b7c4" => :high_sierra
    sha256 "cf27b845d0401e3dbcaedcb590ae61d109a83c99038ba0a98dd984bbc6d458e9" => :sierra
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
