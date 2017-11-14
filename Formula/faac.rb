class Faac < Formula
  desc "ISO AAC audio encoder"
  homepage "http://www.audiocoding.com/faac.html"
  url "https://downloads.sourceforge.net/project/faac/faac-src/faac-1.29/faac-1.29.9.tar.gz"
  sha256 "238cb4453b6fe4eebaffb326e40a63786a155e349955c4259925006fa1e2839e"
  revision 1

  bottle do
    cellar :any
    sha256 "510060abeaaf07eeb01ac4f787239694f8e7798d0673c3658c0280df3844ad9c" => :high_sierra
    sha256 "4bc3356940905426a4a399309c73235dc32abd8f0fad5e449a753a759a9cd080" => :sierra
    sha256 "f8295e1139815ec66a14780a6ee9f0e649f4666ab9faee6983d043114ae82094" => :el_capitan
  end

  # Remove for > 1.29.9
  # 14 Nov 2017 "added joint stereo backward compatibility alias"
  # See https://github.com/knik0/faac/issues/9
  patch do
    url "https://github.com/knik0/faac/commit/eadb150.patch?full_index=1"
    sha256 "770619570b4a85bdceae25855ba72fb1e5644d8ad58096f954cea1dd28297591"
  end

  def install
    # Fix "error: initializer element is not a compile-time constant"
    # Reported 2 Nov 2017 https://sourceforge.net/p/faac/bugs/228/
    inreplace "libfaac/stereo.c", "sqrt(2)", "M_SQRT2"

    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system bin/"faac", test_fixtures("test.mp3"), "-P", "-o", "test.m4a"
    assert_predicate testpath/"test.m4a", :exist?
  end
end
