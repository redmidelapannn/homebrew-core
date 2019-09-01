class ShenSbcl < Formula
  desc "Shen for Steel Bank Common Lisp"
  homepage "https://github.com/Shen-Language/shen-cl"
  url "https://github.com/Shen-Language/shen-cl/archive/v2.5.0.tar.gz"
  sha256 "366225b7df60be56d7622180332bf2db9ddac087c4497ed14eeb7533a765964d"

  bottle do
    cellar :any_skip_relocation
    sha256 "1391d4071b0b0b5807473ef7705cbb1b412c5262845944473d53e8ce445aa0de" => :mojave
    sha256 "8294b2b0dd51cd9a2c7af926df1a9f7016e982984aaeccf68812c2e85ee32e0f" => :high_sierra
    sha256 "9d0caa31d2241922482e38dc4541eac12e80e6b7e63f7e144cd93d8e8a75ce3c" => :sierra
  end

  depends_on "sbcl" => :build

  resource "shen-kernel" do
    url "https://github.com/Shen-Language/shen-sources/releases/download/shen-21.1/ShenOSKernel-21.1.tar.gz"
    sha256 "b71dcaa0289e64b9ef7e19f11502ad47f013bb572871498feccf3cd555d5cf69"
  end

  def install
    ENV.deparallelize
    resource("shen-kernel").stage buildpath/"kernel"
    system "make", "build-sbcl"
    mv "bin/sbcl/shen", "bin/sbcl/shen-sbcl"
    bin.install "bin/sbcl/shen-sbcl"
  end

  test do
    assert_equal "3", shell_output("#{bin}/shen-sbcl -e '(+ 1 2)'")
  end
end
