class OneMl < Formula
  desc "Reboot of ML, unifying its core and (now first-class) module layers"
  homepage "https://www.mpi-sws.org/~rossberg/1ml/"
  url "https://www.mpi-sws.org/~rossberg/1ml/1ml-0.1.zip"
  sha256 "64c40c497f48355811fc198a2f515d46c1bb5031957b87f6a297822b07bb9c9a"
  revision 1

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "bb27ace92b9a4d8053a25680e95139ed0362a03d1c74043253e6f70821fd5e74" => :sierra
    sha256 "486f182fd2d911e5b05936b85ed3dd91e536b4de4ecec0215a7189a64daff0e3" => :el_capitan
    sha256 "00c41c6eed39b57f75be1255df9dd8ed315717f062f053ba7868853baa8e3a20" => :yosemite
  end

  depends_on "ocaml" => :build

  def install
    system "make"
    bin.install "1ml"
    (pkgshare/"stdlib").install Dir.glob("*.1ml")
    doc.install "README.txt"
  end

  test do
    system "#{bin}/1ml", "#{pkgshare}/stdlib/prelude.1ml", "#{pkgshare}/stdlib/paper.1ml"
  end
end
