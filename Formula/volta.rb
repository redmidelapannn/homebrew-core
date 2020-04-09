class Volta < Formula
  desc "JavaScript toolchain manager for reproducible environments"
  homepage "https://volta.sh"
  url "https://github.com/volta-cli/volta.git",
    :revision => "10a9bee148d2a833069d6cc27aea56af3092dc6e",
    :tag      => "v0.7.2"

  bottle do
    cellar :any_skip_relocation
    sha256 "8d84b665093d92ce260ebff1cc3c36a3fc8f0bea975e06278fae7b2d81d12043" => :catalina
    sha256 "9b8299ba11bee6e301e02adf1c16d6f323fcf86cc8c191240a4993a16b508688" => :mojave
    sha256 "b0f1e5d59debf9f5d3348933dcb77bdadc9413fc5c120eaab10ddc3bba7ac0b8" => :high_sierra
  end

  depends_on "rust" => :build

  def install
    ENV["VOLTA_HOME"] = prefix.to_s
    system "./dev/unix/volta-install.sh", "--release", "--skip-setup"
  end

  test do
    system "#{bin}/volta", "install", "node@12.16.1"
    node = shell_output("#{bin}/volta which node").chomp
    assert_match "12.16.1", shell_output("#{node} --version")
  end
end
