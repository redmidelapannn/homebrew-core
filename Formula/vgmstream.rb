class Vgmstream < Formula
  desc "Library for playing streamed audio formats from video games"
  homepage "https://hcs64.com/vgmstream.html"
  url "https://github.com/losnoco/vgmstream/archive/r1050-2838-g987641d8.tar.gz"
  version "r1050-2838-g987641d8"
  sha256 "dc33c572d751cfa644e57addfe447d54c50caaf3f6d7a034b4752b342da167a7"
  head "https://github.com/kode54/vgmstream.git"

  bottle do
    cellar :any
    sha256 "0cf046dbce7de13fcfdb88c2001b93c7855e51959de0218bc1908ccf84c1c7d0" => :catalina
    sha256 "1c331ed8892a03f4ab3535811f5cba14ede2a3956281e418f97340fe71e2c2be" => :mojave
    sha256 "05391d1fbe7103bbbc137af4a83112541eb70ff462f315e00f4293ea7e2f5d20" => :high_sierra
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
