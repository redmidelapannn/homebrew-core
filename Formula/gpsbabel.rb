class Gpsbabel < Formula
  desc "Converts/uploads GPS waypoints, tracks, and routes"
  homepage "https://www.gpsbabel.org/"
  url "https://github.com/gpsbabel/gpsbabel/archive/gpsbabel_1_5_4.tar.gz"
  sha256 "8cd740db0b92610abff71e942e8a987df58cd6ca5f25cca86e15f2b00e190704"
  head "https://github.com/gpsbabel/gpsbabel.git"

  bottle do
    rebuild 1
    sha256 "29ab0a06208c75f2bec9c550c4a9f36f3718ee5f714a56fadb2c8925dd9b0ea7" => :high_sierra
    sha256 "5f21270e763c86350958ddfb5fad6a588c3e25b105d6b4a035c77618fac8f601" => :sierra
    sha256 "d7d48b973863b715106d09d3e23e7d75922ea22446e0365db0b95d1e9cf48a5f" => :el_capitan
  end

  depends_on "libusb" => :optional
  depends_on "qt@5.7"

  # Fix build with Xcode 9, remove for next version
  patch do
    url "https://github.com/gpsbabel/gpsbabel/commit/b7365b93.patch?full_index=1"
    sha256 "e949182def36fef99889e43ba4bc4d61e36d6b95badc74188a8cd3da5156d341"
  end

  def install
    ENV.cxx11
    args = ["--disable-debug", "--disable-dependency-tracking",
            "--prefix=#{prefix}"]
    args << "--without-libusb" if build.without? "libusb"
    system "./configure", *args
    system "make", "install"
  end

  test do
    (testpath/"test.loc").write <<-EOS.undent
      <?xml version="1.0"?>
      <loc version="1.0">
        <waypoint>
          <name id="1 Infinite Loop"><![CDATA[Apple headquarters]]></name>
          <coord lat="37.331695" lon="-122.030091"/>
        </waypoint>
      </loc>
    EOS
    system bin/"gpsbabel", "-i", "geo", "-f", "test.loc", "-o", "gpx", "-F", "test.gpx"
    assert File.exist? "test.gpx"
  end
end
