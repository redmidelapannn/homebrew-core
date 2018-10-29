class Sox < Formula
  desc "SOund eXchange: universal sound sample translator"
  homepage "https://sox.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/sox/sox/14.4.2/sox-14.4.2.tar.gz"
  sha256 "b45f598643ffbd8e363ff24d61166ccec4836fea6d3888881b8df53e3bb55f6c"
  revision 1

  bottle do
    cellar :any
    rebuild 1
    sha256 "ab47269f0a0fd69754704543d6706317cbfac60d1b005b3898f860c4b1049b63" => :mojave
    sha256 "ff9a1eb412ed1f985a2852cb123f461b1fe847c6e9553cd42d43e2b034407787" => :high_sierra
    sha256 "d4ad74d5791ed5c8b89ea64b783cc0af2d3ef71c1f6264aed709b755ab0477b9" => :sierra
  end

  depends_on "pkg-config" => :build
  depends_on "flac"
  depends_on "lame"
  depends_on "libpng"
  depends_on "libvorbis"
  depends_on "mad"
  depends_on "libao" => :optional
  depends_on "libsndfile" => :optional
  depends_on "opencore-amr" => :optional
  depends_on "opusfile" => :optional

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    input = testpath/"test.wav"
    output = testpath/"concatenated.wav"
    cp test_fixtures("test.wav"), input
    system bin/"sox", input, input, output
    assert_predicate output, :exist?
  end
end
