class Icon < Formula
  desc "General-purpose programming language"
  homepage "https://www.cs.arizona.edu/icon/"
  url "https://www.cs.arizona.edu/icon/ftp/packages/unix/icon-v951src.tgz"
  sha256 "062a680862b1c10c21789c0c7c7687c970a720186918d5ed1f7aad9fdc6fa9b9"
  version "9.5.1"

  bottle do
    cellar :any_skip_relocation
    revision 1
    sha256 "47f56451b7072e3bc5d6a8cef252aaf00a01e8399db40af1d76a3a68d2193623" => :el_capitan
    sha256 "2261ae5f0003e08cbd39227f986773776097b8acacc1e1ed56b25403bb564a2d" => :yosemite
    sha256 "778b314a79eb4209ac4e84e62bbf4487f7a50347d9b87fc363ad1e3a1960a40a" => :mavericks
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
