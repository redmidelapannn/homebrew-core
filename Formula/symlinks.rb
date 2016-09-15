class Symlinks < Formula
  desc "is a simple tool to help find and remedy problematic symbolic links."
  homepage "https://github.com/brandt/symlinks"
  url "https://github.com/brandt/symlinks/archive/v1.4.3.tar.gz"
  sha256 "27105b2898f28fd53d52cb6fa77da1c1f3b38e6a0fc2a66bf8a25cd546cb30b2"

  bottle do
    cellar :any_skip_relocation
    sha256 "4081daa80041952e0683e0699daddf47bb677a95b9263f6aca567e8710f5c432" => :yosemite
    sha256 "54cb05b5384e89fe135c5f78a68f4453dc17db1ea636ac96f367165c99c409c7" => :mavericks
  end

  def install
    system "make", "install"
    bin.install "symlinks"
  end

  test do
    system "#{bin}/symlinks"
  end
end
