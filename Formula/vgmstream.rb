class Vgmstream < Formula
  desc "Library for playing streamed audio formats from video games"
  homepage "https://hcs64.com/vgmstream.html"
  url "https://github.com/losnoco/vgmstream/archive/r1050-2838-g987641d8.tar.gz"
  version "r1050-2838-g987641d8"
  sha256 "dc33c572d751cfa644e57addfe447d54c50caaf3f6d7a034b4752b342da167a7"
  head "https://github.com/kode54/vgmstream.git"

  bottle do
    cellar :any
    sha256 "e999d79d61402e4f297b49d0b634d01bc5ff10ff27f2bb61c9859dacca104ef9" => :catalina
    sha256 "d180afb14e4343b8820c189ea1e857157d81973683923c06e9f58dcfbeacc247" => :mojave
    sha256 "d4a4e8c4652075288e44abfee2ffc56690a1f84b14e126a0dc0746123bb337ee" => :high_sierra
    sha256 "c743fe265464bd875289a5ae0db662654587f2a9e29ef1b8851bc5312d951041" => :sierra
  end

  depends_on "libao"
  depends_on "libvorbis"
  depends_on "mpg123"

  def install
    system "make", "vgmstream_cli"
    system "make", "vgmstream123"
    bin.install "cli/vgmstream-cli"
    bin.install "cli/vgmstream123"
    lib.install "src/libvgmstream.a"
  end

  test do
    assert_match "decode", shell_output("#{bin}/vgmstream-cli 2>&1", 1)
  end
end
