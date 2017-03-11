class Vgmstream < Formula
  desc "Library for playing streamed audio formats from video games"
  homepage "https://hcs64.com/vgmstream.html"
  url "https://svn.code.sf.net/p/vgmstream/code", :revision => 1040
  version "r1040"

  bottle do
    cellar :any
    rebuild 1
    sha256 "ee64d94a601d104631f890a2200d1da0681835457f424ec8a69f1d62242a25f0" => :sierra
  end

  depends_on "mpg123"
  depends_on "libvorbis"

  def install
    cd "test" do
      system "make"
      bin.install "test" => "vgmstream"
      lib.install "../src/libvgmstream.a"
    end
  end
end
