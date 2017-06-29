class Trash < Formula
  desc "CLI tool that moves files or folder to the trash"
  homepage "http://hasseg.org/trash/"
  url "https://github.com/ali-rantakari/trash/archive/v0.8.5.tar.gz"
  sha256 "1e08fdcdeaa216be1aee7bf357295943388d81e62c2c68c30c830ce5c43aae99"
  head "https://github.com/ali-rantakari/trash.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "1eab1cc79f33ce1ee94c6b36413dc5b697d4d8ceb486d718aa753316cc93619e" => :sierra
    sha256 "79e7d3445d173b57fcb1b0df0b824e1c1de09732e5fbecbd4f9d2b3a1b4546bc" => :el_capitan
    sha256 "248aaa608d10cc46e34c4c4f5995878763112c8aed97b8c56303fccf3e047f59" => :yosemite
  end

  conflicts_with "osxutils", :because => "both install a trash binary"

  def install
    system "make"
    system "make", "docs"
    bin.install "trash"
    man1.install "trash.1"
  end

  test do
    system "#{bin}/trash"
  end
end
