class Codec2 < Formula
  desc "Open source speech codec"
  homepage "https://www.rowetel.com/?page_id=452"
  url "https://freedv.com/wp-content/uploads/sites/8/2017/10/codec2-0.7.tar.xz"
  sha256 "0695bb93cd985dd39f02f0db35ebc28a98b9b88747318f90774aba5f374eadb2"

  bottle do
    cellar :any
    rebuild 1
    sha256 "9d8f3492241ab8a53b4d4154a39abc24d46f992f935530d98df21732b77d7e35" => :high_sierra
    sha256 "72c4abf8a8cd2223b346020165a9b3419439cec41968f2fef545cbe9d6ea610e" => :sierra
    sha256 "5a1949ce98d73ba4ad875934d456a8ff9d6f6f790862f9983e70f940ba07b45b" => :el_capitan
  end

  depends_on "cmake" => :build

  def install
    mkdir "build_osx" do
      system "cmake", "..", *std_cmake_args
      system "make", "install"
    end
  end

  test do
    # 8 bytes of raw audio data (silence).
    (testpath/"test.raw").write([0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00].pack("C*"))
    system "#{bin}/c2enc", "2400", "test.raw", "test.c2"
  end
end
