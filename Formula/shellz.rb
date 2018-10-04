class Shellz < Formula
  desc "Small utility to track and control custom shellz"
  homepage "https://github.com/evilsocket/shellz"
  url "https://github.com/evilsocket/shellz/archive/v1.1.0.tar.gz"
  sha256 "8bec29e04a54adb8b9d161c88422d324e1f3d52d743f4fc0d72ab89ca54f9c1e"

  bottle do
    cellar :any_skip_relocation
    sha256 "df5086226ef3ed114bf0fcf44f64c8c0b36b757bd47c61d8da3008e9390b39ac" => :mojave
    sha256 "5df4ff08c501c39ffe23ab3a8e2a2c8915fb5202882218df95db11bd3b147d11" => :high_sierra
    sha256 "fd826abd1c8340dfc4b54a61d6a3e801a221920f5708bd4346eb80b6aad1fc22" => :sierra
  end

  depends_on "dep" => :build
  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    (buildpath/"src/github.com/evilsocket/shellz").install buildpath.children

    cd "src/github.com/evilsocket/shellz" do
      system "dep", "ensure", "-vendor-only"
      system "make", "build"
      bin.install "shellz"
      prefix.install_metafiles
    end
  end

  test do
    assert_match "shellz", shell_output("#{bin}/shellz -help 2>&1", 2)
  end
end
