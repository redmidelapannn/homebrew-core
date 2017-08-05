class Scummvm < Formula
  desc "Graphic adventure game interpreter"
  homepage "https://www.scummvm.org/"
  url "https://www.scummvm.org/frs/scummvm/1.9.0/scummvm-1.9.0.tar.xz"
  sha256 "2417edcb1ad51ca05a817c58aeee610bc6db5442984e8cf28e8a5fd914e8ae05"
  head "https://github.com/scummvm/scummvm.git"

  bottle do
    rebuild 1
    sha256 "9354d39cf08cfd7dc39add91b37a147ffb209d1d0c42ddb8527868fe53c88a7b" => :sierra
    sha256 "80dae3fe71dfd100c08ce81621bee8e9bd076a49cfca5a8e08d8d083ba849e20" => :el_capitan
    sha256 "f81d36a140c34eb821be6f61c554691f5b008c13046ef1fbb209f00c5a40f818" => :yosemite
  end

  depends_on "faad2"
  depends_on "flac"
  depends_on "fluid-synth"
  depends_on "freetype"
  depends_on "jpeg"
  depends_on "libpng"
  depends_on "libvorbis"
  depends_on "mad"
  depends_on "sdl2"
  depends_on "theora"

  def install
    system "./configure", "--prefix=#{prefix}", "--enable-release"
    system "make"
    system "make", "install"
    (share+"pixmaps").rmtree
    (share+"icons").rmtree
  end

  test do
    system "#{bin}/scummvm", "-v"
  end
end
