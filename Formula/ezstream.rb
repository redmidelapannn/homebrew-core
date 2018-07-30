class Ezstream < Formula
  desc "Client for Icecast streaming servers"
  homepage "https://icecast.org/ezstream/"
  url "https://downloads.xiph.org/releases/ezstream/ezstream-0.6.0.tar.gz"
  sha256 "f86eb8163b470c3acbc182b42406f08313f85187bd9017afb8b79b02f03635c9"

  bottle do
    cellar :any
    rebuild 2
    sha256 "741857c766061229264101c6410132d2714d50cc395805c89fb8b1fd06445c60" => :high_sierra
    sha256 "6bb7748022714c7e5207cde3e6bfece0a5d949df82592eec99e89a6007f65f35" => :sierra
    sha256 "1f24ea06a833170bd7b7c143d73d2c2fb3b391afd5ec05875f4dd093ad92d403" => :el_capitan
  end

  depends_on "pkg-config" => :build
  depends_on "libvorbis"
  depends_on "libshout"
  depends_on "theora"
  depends_on "speex"
  depends_on "libogg"

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test.m3u").write test_fixtures("test.mp3").to_s
    system bin/"ezstream", "-s", testpath/"test.m3u"
  end
end
