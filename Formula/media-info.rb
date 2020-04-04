class MediaInfo < Formula
  desc "Unified display of technical and tag data for audio/video"
  homepage "https://mediaarea.net/"
  url "https://mediaarea.net/download/binary/mediainfo/20.03/MediaInfo_CLI_20.03_GNU_FromSource.tar.bz2"
  sha256 "3ea86061ba398c2f57292dc1c844a8962481fb2c8984be424ba6ffa746b83d3e"

  bottle do
    cellar :any
    sha256 "529694395f6c20486f127d991f577b88724d345233e4110eaf2a485a52d6df51" => :catalina
    sha256 "066c6ee834866c8aaef54d34cc44417222bf1688d64ed6541799e3863f86f625" => :mojave
    sha256 "18860f35af7c61b4ed99fa239552562a82109aaa9f885699e84e02a3f70b11af" => :high_sierra
  end

  depends_on "pkg-config" => :build

  uses_from_macos "curl"
  uses_from_macos "zlib"

  def install
    cd "ZenLib/Project/GNU/Library" do
      args = ["--disable-debug",
              "--disable-dependency-tracking",
              "--enable-static",
              "--enable-shared",
              "--prefix=#{prefix}"]
      system "./configure", *args
      system "make", "install"
    end

    cd "MediaInfoLib/Project/GNU/Library" do
      args = ["--disable-debug",
              "--disable-dependency-tracking",
              "--with-libcurl",
              "--enable-static",
              "--enable-shared",
              "--prefix=#{prefix}"]
      system "./configure", *args
      system "make", "install"
    end

    cd "MediaInfo/Project/GNU/CLI" do
      system "./configure", "--disable-debug", "--disable-dependency-tracking",
                            "--prefix=#{prefix}"
      system "make", "install"
    end
  end

  test do
    pipe_output("#{bin}/mediainfo", test_fixtures("test.mp3"))
  end
end
