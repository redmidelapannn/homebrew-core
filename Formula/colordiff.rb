class Colordiff < Formula
  desc "Color-highlighted diff(1) output"
  homepage "https://www.colordiff.org/"
  url "https://www.colordiff.org/colordiff-1.0.18.tar.gz"
  mirror "https://dl.bintray.com/homebrew/mirror/colordiff-1.0.18.tar.gz"
  sha256 "29cfecd8854d6e19c96182ee13706b84622d7b256077df19fbd6a5452c30d6e0"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "cb6276e09e062f2b1b718d75b3877efc97448e8f1df51618e920aa589247877b" => :catalina
    sha256 "cb6276e09e062f2b1b718d75b3877efc97448e8f1df51618e920aa589247877b" => :mojave
    sha256 "cb6276e09e062f2b1b718d75b3877efc97448e8f1df51618e920aa589247877b" => :high_sierra
  end

  conflicts_with "cdiff", :because => "both install `cdiff` binaries"

  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/85fa66a9/colordiff/1.0.16.patch"
    sha256 "715ae7c2f053937606c7fe576acbb7ab6f2c58d6021a9a0d40e7c64a508ec8d0"
  end

  def install
    man1.mkpath
    system "make", "INSTALL_DIR=#{bin}",
                   "ETC_DIR=#{etc}",
                   "MAN_DIR=#{man1}",
                   "install"
  end

  test do
    cp HOMEBREW_PREFIX+"bin/brew", "brew1"
    cp HOMEBREW_PREFIX+"bin/brew", "brew2"
    system "#{bin}/colordiff", "brew1", "brew2"
  end
end
