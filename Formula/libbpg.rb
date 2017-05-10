class Libbpg < Formula
  desc "Image format meant to improve on JPEG quality and file size"
  homepage "https://bellard.org/bpg/"
  url "https://bellard.org/bpg/libbpg-0.9.7.tar.gz"
  sha256 "05035862ff4ffca0280261871486f44e74c4af4337c931e0858483551e6efe25"

  bottle do
    cellar :any
    rebuild 1
    sha256 "b49567aafe26bd122da71385849f35d0de22989cb2f07d3b1a7734a9e1310bea" => :sierra
    sha256 "8ba1cc66ffe6049d5b132d7efd6d7e4b8e56bef31e26aaf5fcd9ff98188a18e1" => :el_capitan
    sha256 "8ce91888c4f953cf3e2e1beb65c6a5f183380e88bc6cdc8947e3ac77a2c458bf" => :yosemite
  end

  option "with-jctvc", "Enable built-in JCTVC encoder - Mono threaded, slower but produce smaller file"
  option "without-x265", "Disable built-in x265 encoder - Multi threaded, faster but produce bigger file"

  depends_on "cmake" => :build
  depends_on "yasm" => :build if build.with? "x265"
  depends_on "libpng"
  depends_on "jpeg"

  def install
    bin.mkpath

    args = []
    args << "USE_JCTVC=y" if build.with? "jctvc"
    args << "USE_X265=" if build.without? "x265"

    system "make", "install", "prefix=#{prefix}", "CONFIG_APPLE=y", *args

    pkgshare.install Dir["html/bpgdec*.js"]
  end

  test do
    system "#{bin}/bpgenc", test_fixtures("test.png")
  end
end
