class NowCli < Formula
  desc "The command-line interface for Realtime global deployments."
  homepage "https://zeit.co/now"
  url "https://github.com/zeit/now-cli/releases/download/7.0.2/now-macos"
  version "7.0.2"
  sha256 "5dce15bc8af083bee4647fb1b5f7861f6813bd2e86128a26858627a5c882d1df"

  def install
    bin.install "now-macos"
    mv bin/"now-macos", bin/"now"
  end

  test do
    expected = <<-EOS.undent
      7.0.2
    EOS
    cmd = "#{bin}/now -v"
    assert_equal expected, shell_output(cmd)
  end
end
