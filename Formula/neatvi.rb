class Neatvi < Formula
  desc "ex/vi clone for editing bidirectional uft-8 text"
  homepage "http://repo.or.cz/w/neatvi.git"
  url "http://repo.or.cz/neatvi.git",
    :tag => "06", :revision => "5ed4bbc7f12686bb480ab8b2b05c94e12b1c71d8"

  head "http://repo.or.cz/neatvi.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "ffb0222388530c840c5b301f5d39e5039cb7465dbf582ba0762b80994d5204dd" => :high_sierra
    sha256 "5b60461e4db36db367fd65ed7857d625c1d67012a45e29501c8707fb87c64fe2" => :sierra
    sha256 "3f8e00be41864e3c9ff58175ece334cdea84ffac063cdc39d1bee925c370d57d" => :el_capitan
  end

  def install
    system "make"
    bin.install "vi" => "neatvi"
  end

  test do
    pipe_output("#{bin}/neatvi", ":q\n")
  end
end
