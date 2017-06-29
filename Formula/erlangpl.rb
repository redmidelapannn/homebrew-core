class Erlangpl < Formula
  desc "Tool for developers working with systems on the Erlang VM (BEAM)."
  homepage "http://www.erlang.pl/"
  url "https://github.com/erlanglab/erlangpl/releases/download/0.7.0/erlangpl.tar.gz"
  sha256 "f67c85024300a958e4ee582b24b87bee25a3f4a2325d7190585611212f4f8191"

  bottle do
    cellar :any_skip_relocation
    sha256 "831029ef6ff515132c516c342f2231c8b525254c8d4070f00b046519dc281f95" => :sierra
    sha256 "ac86f066840625332f3f38910829d0045ca38f734b5ba2a43bcbe592d901a1dd" => :el_capitan
    sha256 "ac86f066840625332f3f38910829d0045ca38f734b5ba2a43bcbe592d901a1dd" => :yosemite
  end

  depends_on "erlang"

  def install
    bin.install "erlangpl" => "erlangpl"
  end

  test do
    system "#{bin}/erlangpl", "--version"
  end
end
