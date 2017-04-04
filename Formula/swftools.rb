class Swftools < Formula
  desc "SWF manipulation and generation tools"
  homepage "http://www.swftools.org/"
  url "http://www.swftools.org/swftools-0.9.2.tar.gz"
  sha256 "bf6891bfc6bf535a1a99a485478f7896ebacbe3bbf545ba551298080a26f01f1"
  revision 2

  bottle do
    sha256 "546605acae5c556b3ae3d59ce93d4a5d761cfdcf6567aebfff944a631f251c24" => :sierra
    sha256 "4304bb368d99311af801acb691fd90e7b1f54952f143a95f3dbf91aeb9fa13d0" => :el_capitan
    sha256 "df41e6a5bb2a0f213e0e147764e7833fbabb4992c303a0e108bf14602a233bb3" => :yosemite
  end

  option "with-xpdf", "Build with PDF support"

  depends_on :x11 if build.with? "xpdf"
  depends_on "jpeg" => :optional
  depends_on "lame" => :optional
  depends_on "giflib@4" => :optional
  depends_on "fftw" => :optional

  resource "xpdf" do
    url "ftp://ftp.foolabs.com/pub/xpdf/xpdf-3.04.tar.gz", :using => :nounzip
    sha256 "11390c74733abcb262aaca4db68710f13ffffd42bfe2a0861a5dfc912b2977e5"
  end

  # Fixes a conftest for libfftwf.dylib that mistakenly calls fftw_malloc()
  # rather than fftwf_malloc().  Reported upstream to their mailing list:
  # https://lists.nongnu.org/archive/html/swftools-common/2012-04/msg00014.html
  # Patch is merged upstream.  Remove at swftools-0.9.3.
  patch :DATA

  # Fix compile error, via MacPorts: https://trac.macports.org/ticket/34553
  patch :p0 do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/96d3ae5/swftools/patch-src_gif2swf.c.diff"
    sha256 "75daa35a292a25d05b45effc5b734e421b437bad22479837e0ee5cbd7a05e73e"
  end

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
