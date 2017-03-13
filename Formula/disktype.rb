class Disktype < Formula
  desc "Detect content format of a disk or disk image"
  homepage "https://disktype.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/disktype/disktype/9/disktype-9.tar.gz"
  sha256 "b6701254d88412bc5d2db869037745f65f94b900b59184157d072f35832c1111"
  head "https://git.code.sf.net/p/disktype/disktype.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "a0640fa72675c484c0186c50a1b1a6638fabe3f924edbd285f27bd59472ce9e4" => :sierra
    sha256 "c71275fef52f22ab6395d1b308649e04f1e39b9b38ba92ee3ec9a0d7ac9a42e5" => :el_capitan
    sha256 "a1abbcb634f83e3269b0bf11830837e92fb2098a1ed664fea737edea4525eeb0" => :yosemite
  end

  def install
    system "make"
    bin.install "disktype"
    man1.install "disktype.1"
  end

  test do
    path = testpath/"foo"
    path.write "1234"

    output = shell_output("#{bin}/disktype #{path}")
    assert_match "Regular file, size 4 bytes", output
  end
end
