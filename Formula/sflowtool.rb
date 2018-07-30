class Sflowtool < Formula
  desc "Utilities and scripts for analyzing sFlow data"
  homepage "https://inmon.com/technology/sflowTools.php"
  url "https://github.com/sflow/sflowtool/releases/download/v3.41/sflowtool-3.41.tar.gz"
  sha256 "0e807f182db5ca5b37d0fb55b77e970b1d51fee0cd8cb845646211befb35ca24"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "e7d4dc980257d5d9b3b518dee641bc3d5e58666a55f78c38171682a11c6ca0c3" => :high_sierra
    sha256 "53202e0f6f168f43cb2aa2a25151c6dbc736aeddf2761bc22b2f4b042cfb4b89" => :sierra
    sha256 "49d4ba1cbc136364b2eba88ccd2313225143d72bf9ca8c511d8282610c0ed22e" => :el_capitan
  end

  resource "scripts" do
    url "https://inmon.com/bin/sflowutils.tar.gz"
    sha256 "45f6a0f96bdb6a1780694b9a4ef9bbd2fd719b9f7f3355c6af1427631b311d56"
  end

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make"
    system "make", "check"
    system "make", "install"
    (prefix/"contrib").install resource("scripts")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/sflowtool -h 2>&1")
  end
end
