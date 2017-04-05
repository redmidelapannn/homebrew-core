class Sox < Formula
  desc "SOund eXchange: universal sound sample translator"
  homepage "https://sox.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/sox/sox/14.4.2/sox-14.4.2.tar.gz"
  sha256 "b45f598643ffbd8e363ff24d61166ccec4836fea6d3888881b8df53e3bb55f6c"

  bottle do
    cellar :any
    rebuild 1
    sha256 "cc99c1145ba1dd729a1b5040339de190a652d5e2e7b980f8c55880dccb3b41ab" => :sierra
    sha256 "15d211b03ecd9b1c9e8db7d982c80f2f0e96d73cc76cd998189bbfb412b3b50f" => :el_capitan
    sha256 "9d007f9127c8981ccbe22f4214550dce8841eb97a2c4656e2eaae15d0bbcbc43" => :yosemite
  end

  depends_on "pkg-config" => :build
  depends_on "libpng"
  depends_on "mad"
  depends_on "opencore-amr" => :optional
  depends_on "opusfile" => :optional
  depends_on "libvorbis" => :optional
  depends_on "flac" => :optional
  depends_on "libsndfile" => :optional
  depends_on "libao" => :optional
  depends_on "lame" => :optional

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
    system "#{bin}/sox #{input} #{input} #{output}"
    assert_predicate output, :exist?
  end
end
