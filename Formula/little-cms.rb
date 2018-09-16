class LittleCms < Formula
  desc "Version 1 of the Little CMS library"
  homepage "http://www.littlecms.com/"
  url "https://downloads.sourceforge.net/project/lcms/lcms/1.19/lcms-1.19.tar.gz"
  sha256 "80ae32cb9f568af4dc7ee4d3c05a4c31fc513fc3e31730fed0ce7378237273a9"
  revision 1

  bottle do
    cellar :any
    rebuild 1
    sha256 "0e7861aed55c76eaa13f06774d025bd776e365fa2643c727f303602ad4f95cfa" => :mojave
    sha256 "6245b6da6c95756319d5b4254753f48ea30cc6197c1bc66311527fdf117ef809" => :high_sierra
    sha256 "8681df0244b286902975a883bbb4da68286fddbc57e0f642338102327be59700" => :sierra
    sha256 "25005b6a57fb0a5554094fc44a0029abb728d6419d65dfc15a25e893f1e31810" => :el_capitan
  end

  depends_on "jpeg"
  depends_on "libtiff"

  def install
    args = %W[--disable-dependency-tracking --disable-debug --prefix=#{prefix}]
    system "./configure", *args

    system "make"
    ENV.deparallelize
    system "make", "install"
  end

  test do
    system "#{bin}/jpegicc", test_fixtures("test.jpg"), "out.jpg"
    assert_predicate testpath/"out.jpg", :exist?
  end
end
