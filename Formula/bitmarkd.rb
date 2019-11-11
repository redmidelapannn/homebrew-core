class Bitmarkd < Formula
  desc "Bitmark distributed property system"
  homepage "https://github.com/bitmark-inc/bitmarkd"
  url "https://github.com/bitmark-inc/bitmarkd/archive/v0.12.0.tar.gz"
  sha256 "aa492d3aa4436671e14b1a5f1853159e6c644eeb3c2b9b5d878bdf80bd5cd933"
  head "https://github.com/bitmark-inc/bitmarkd.git"

  bottle do
    cellar :any
    sha256 "986ed9773e66aa43b1902fdbffdc61b9de747b9a46a14079b75cf18537393170" => :catalina
    sha256 "2a077849cd1d1fce781f1ded3c1d3e647bf195e0ac4feafbfd16881334e64796" => :mojave
    sha256 "102a9753903baa448fb035f0a121e0f17ec54a71e7a769a587f79fcd56bc1782" => :high_sierra
  end

  depends_on "go" => :build
  depends_on "pkg-config" => :build
  depends_on "argon2"
  depends_on "zeromq"

  def install
    system "go", "build", "-o", ".", "-ldflags", "-X main.version=#{version}", "./..."
    bin.install "bitmarkd", "bitmark-cli", "recorderd", "bitmark-info"
    prefix.install_metafiles
  end

  test do
    assert_match "bitmarkd: version: 0.12.0", shell_output("#{bin}/bitmarkd --version 2>&1", 1)
    assert_match "recorderd: version: 0.12.0", shell_output("#{bin}/recorderd --version 2>&1", 1)
    assert_match "bitmark-info: version: 0.12.0", shell_output("#{bin}/bitmark-info --version 2>&1", 1)
    assert_match version.to_s, shell_output("#{bin}/bitmark-cli version")
  end
end
