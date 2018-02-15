class VorbisTools < Formula
  desc "Ogg Vorbis CODEC tools"
  homepage "https://github.com/xiph/vorbis-tools"
  url "https://downloads.xiph.org/releases/vorbis/vorbis-tools-1.4.0.tar.gz"
  sha256 "a389395baa43f8e5a796c99daf62397e435a7e73531c9f44d9084055a05d22bc"
  revision 1

  bottle do
    rebuild 2
    sha256 "c451ff5710c662a26ec7202b9342a1e920e15681540320e1cce86dc75fd57b39" => :high_sierra
    sha256 "afdbf54f0decd2221b7a8e231549376de83a9d2d2a9e4adb6ff6d867865c3146" => :sierra
    sha256 "0bc7ddfa8bce0070ff548d47d3f3c8bd53751132ab612b7bb099de4820a7bc1f" => :el_capitan
  end

  depends_on "pkg-config" => :build
  depends_on "libogg"
  depends_on "libvorbis"
  depends_on "libao"
  depends_on "flac" => :optional

  def install
    # Fix `brew linkage --test` "Missing libraries: /usr/lib/libnetwork.dylib"
    # Prevent bogus linkage to the libnetwork.tbd in Xcode 7's SDK
    ENV.delete("SDKROOT") if MacOS.version == :yosemite

    args = %W[
      --disable-debug
      --disable-dependency-tracking
      --disable-nls
      --prefix=#{prefix}
    ]

    args << "--without-flac" if build.without? "flac"

    system "./configure", *args
    system "make", "install"
  end

  test do
    system bin/"oggenc", test_fixtures("test.wav"), "-o", "test.ogg"
    assert_predicate testpath/"test.ogg", :exist?
    output = shell_output("#{bin}/ogginfo test.ogg")
    assert_match "20.625000 kb/s", output
  end
end
