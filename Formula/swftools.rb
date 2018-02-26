class Swftools < Formula
  desc "SWF manipulation and generation tools"
  homepage "http://www.swftools.org/"
  url "http://www.swftools.org/swftools-0.9.2.tar.gz"
  sha256 "bf6891bfc6bf535a1a99a485478f7896ebacbe3bbf545ba551298080a26f01f1"
  revision 1

  bottle do
    rebuild 1
    sha256 "2a95a0fb3ae71bdad5432193691a33adcbc7d6c227f7ad27fbf963797b78834e" => :high_sierra
    sha256 "5bd58543d4e81191afdac61ae4ee0a7d404283058d87ae50363d0fa3b1a829bb" => :sierra
    sha256 "995b9034661af169556d209f5332415000243e9beeb9b2fef3c9d0f9f98da364" => :el_capitan
  end

  option "with-xpdf", "Build with PDF support"

  depends_on :x11 if build.with? "xpdf"
  depends_on "jpeg" => :optional
  depends_on "lame" => :optional
  depends_on "fftw" => :optional

  resource "xpdf" do
    url "https://src.fedoraproject.org/repo/pkgs/xpdf/xpdf-3.04.tar.gz/3bc86c69c8ff444db52461270bef3f44/xpdf-3.04.tar.gz", :using => :nounzip
    sha256 "11390c74733abcb262aaca4db68710f13ffffd42bfe2a0861a5dfc912b2977e5"
  end

  # Fixes a conftest for libfftwf.dylib that mistakenly calls fftw_malloc()
  # rather than fftwf_malloc().  Reported upstream to their mailing list:
  # https://lists.nongnu.org/archive/html/swftools-common/2012-04/msg00014.html
  # Patch is merged upstream.  Remove at swftools-0.9.3.
  patch :DATA

  def install
    (buildpath/"lib/pdf").install resource("xpdf") if build.with? "xpdf"
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    system "#{bin}/png2swf", "swftools_test.swf", test_fixtures("test.png")
  end
end

__END__
--- a/configure	2012-04-08 10:25:35.000000000 -0700
+++ b/configure	2012-04-09 17:42:10.000000000 -0700
@@ -6243,7 +6243,7 @@
 
     int main()
     {
-	char*data = fftw_malloc(sizeof(fftwf_complex)*600*800);
+	char*data = fftwf_malloc(sizeof(fftwf_complex)*600*800);
     	fftwf_plan plan = fftwf_plan_dft_2d(600, 800, (fftwf_complex*)data, (fftwf_complex*)data, FFTW_FORWARD, FFTW_ESTIMATE);
 	plan = fftwf_plan_dft_r2c_2d(600, 800, (float*)data, (fftwf_complex*)data, FFTW_ESTIMATE);
 	plan = fftwf_plan_dft_c2r_2d(600, 800, (fftwf_complex*)data, (float*)data, FFTW_ESTIMATE);
