class Sox < Formula
  desc "SOund eXchange: universal sound sample translator"
  homepage "https://sox.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/sox/sox/14.4.2/sox-14.4.2.tar.gz"
  sha256 "b45f598643ffbd8e363ff24d61166ccec4836fea6d3888881b8df53e3bb55f6c"

  bottle do
    cellar :any
    rebuild 1
    sha256 "e6c1bfbd71f33b329263c0062647dbe38b1a359003191c07472c84db24256cd9" => :high_sierra
    sha256 "9c9773cfb04dbdc36a3c427fa67f1575653c5356f912baab8c70756079bbadde" => :sierra
    sha256 "e0d892a922653f5352b54583e659fd47d94f73ffb9c7783991df5ed3b7513ce3" => :el_capitan
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
    system "#{bin}/sox", "#{input}.to_s", "#{input}.to_s", "#{output}.to_s"
    assert_predicate output, :exist?
  end
end
