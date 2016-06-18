class Musepack < Formula
  desc "Audio compression format and tools"
  homepage "https://www.musepack.net/"
  url "https://files.musepack.net/source/musepack_src_r475.tar.gz"
  version "r475"
  sha256 "a4b1742f997f83e1056142d556a8c20845ba764b70365ff9ccf2e3f81c427b2b"

  bottle do
    cellar :any
    revision 1
    sha256 "aed8168fe26d4cf17e379eeda7adecca8921bc5d6b3f9b1bccaac2b2a3edeeb3" => :el_capitan
    sha256 "2ef3f13177cb952f5d54ae9f146a1482df70d8533308de9b41aace2e202992a7" => :yosemite
    sha256 "9fdd65075242c876099dfd23b0eafe8f316ff3b95b11f44c4ace78e9fb9206a2" => :mavericks
  end

  depends_on "cmake" => :build
  depends_on "libcuefile"
  depends_on "libreplaygain"

  resource "test-mpc" do
    url "https://trac.ffmpeg.org/raw-attachment/ticket/1160/decodererror.mpc"
    sha256 "b16d876b58810cdb7fc06e5f2f8839775efeffb9b753948a5a0f12691436a15c"
  end

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
    lib.install "libmpcdec/libmpcdec.dylib"
  end

  test do
    resource("test-mpc").stage do
      assert_match(/441001 samples decoded in/,
                   shell_output("#{bin}/mpcdec decodererror.mpc 2>&1"))
    end
  end
end
