class Trash < Formula
  desc "CLI tool that moves files or folder to the trash"
  homepage "http://hasseg.org/trash/"
  url "https://github.com/ali-rantakari/trash/archive/v0.8.5.tar.gz"
  sha256 "1e08fdcdeaa216be1aee7bf357295943388d81e62c2c68c30c830ce5c43aae99"
  head "https://github.com/ali-rantakari/trash.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "65fa09ddaa5fb5c7ef1162a1394f834c615a36bc15d995ecfb22bd7426e15ecf" => :sierra
    sha256 "e449295040751daf892f72bf41b7218244699ca2fb2cfefb1f66afcbfa7326a9" => :el_capitan
  end

  conflicts_with "osxutils", :because => "both install a `trash` binary"
  conflicts_with "trash-cli", :because => "both install a `trash` binary"

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
