class Residualvm < Formula
  desc "3D graphic adventure game interpreter"
  homepage "http://residualvm.org"
  url "https://downloads.sourceforge.net/project/residualvm/residualvm/0.2.1/residualvm-0.2.1-sources.tar.bz2"
  sha256 "cd2748a665f80b8c527c6dd35f8435e718d2e10440dca10e7765574c7402d924"
  head "https://github.com/residualvm/residualvm.git"

  bottle do
    rebuild 1
    sha256 "8b48d96ae5d7e3dd033f4220f5b05bc787e758de0daf0c22c0e31b1dc71c227b" => :sierra
    sha256 "7375f5e5f7a3822134e2b35e54cae0b2be77193448faf09386fbe3e5076e4383" => :el_capitan
    sha256 "de4419d11625179b60c70161c9bb866f956f48526361000f2077f1acbaec87a8" => :yosemite
  end

  depends_on "faad2"
  depends_on "flac"
  depends_on "fluid-synth"
  depends_on "freetype"
  depends_on "jpeg"
  depends_on "libpng"
  depends_on "libvorbis"
  depends_on "mad"
  depends_on "sdl"
  depends_on "theora"

  def install
    system "./configure", "--prefix=#{prefix}", "--enable-release"
    system "make"
    system "make", "install"
    (share+"icons").rmtree
    (share+"pixmaps").rmtree
  end

  test do
    system "#{bin}/residualvm", "-v"
  end
end
