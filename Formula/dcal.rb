class Dcal < Formula
  desc "dcal(1) is to cal(1) what ddate(1) is to date(1)"
  homepage "https://alexeyt.freeshell.org/"
  url "https://alexeyt.freeshell.org/code/dcal.c"
  version "0.1.0"
  sha256 "d637fd27fc8d2a3c567b215fc05ee0fd9d88ba9fc5ddd5f0b07af3b8889dcba7"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "6275289fe9fa8d0beae85bcce96250ebc11221901cdb21472f2d10f5bcf4baac" => :high_sierra
    sha256 "333a3e6048cb34f18798f01bdede65d9c449bd3a163a3f87a7d7fbc9b76cc7b6" => :sierra
    sha256 "657029ee919b71fd4994f4cb01fea7cfc81eedadefa14efecdbb0088729f04fb" => :el_capitan
  end

  def install
    system ENV.cxx, "dcal.c", "-o", "dcal"
    bin.install "dcal"
  end

  test do
    system "#{bin}/dcal", "-3"
  end
end
