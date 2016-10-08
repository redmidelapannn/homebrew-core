class Icon < Formula
  desc "General-purpose programming language"
  homepage "https://www.cs.arizona.edu/icon/"
  url "https://www.cs.arizona.edu/icon/ftp/packages/unix/icon-v951src.tgz"
  version "9.5.1"
  sha256 "062a680862b1c10c21789c0c7c7687c970a720186918d5ed1f7aad9fdc6fa9b9"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "d559526647c1786f0289fd8048758fdd3e7998c894ced0b0203494ca2d268ae8" => :sierra
    sha256 "2805d5740c99f561fbf101b77eedf79e7e16c9c860a2afaf95a5ac9034ff2d2f" => :el_capitan
    sha256 "d380fd71e41bdbaa85f989f66833b0442502b85b2ead36b26f33a67d339f0b4f" => :yosemite
  end

  def install
    ENV.deparallelize
    system "make", "Configure", "name=posix"
    system "make"
    bin.install "bin/icon", "bin/icont", "bin/iconx"
    doc.install Dir["doc/*"]
    man1.install Dir["man/man1/*.1"]
  end

  test do
    assert_equal "Hello, World!", shell_output("#{bin}/icon -P 'procedure main(); writes(\"Hello, World!\"); end'")
  end
end
