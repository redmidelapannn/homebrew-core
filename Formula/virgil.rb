class Virgil < Formula
  desc "CLI tool to manage your Virgil account and applications"
  homepage "https://github.com/VirgilSecurity/virgil-cli"
  url "https://github.com/VirgilSecurity/virgil-cli/releases/download/v5.0.1/virgil_5.0.1_macOS_x86_64.tar.gz"
  sha256 "0f149c695e6809f48c5f86fd5d8fea35d9eb787f0792aae6c4edfcd00d99206c"

  def install
    bin.install "virgil"
  end

  test do
    result = %x(`virgil pure keygen`)
    assert_true result.start_with?("SK.1.")
  end
end
