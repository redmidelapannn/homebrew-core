class Wapm < Formula
  desc "📦 WebAssembly Package Manager (CLI)"
  homepage "https://wapm.io/"
  url "https://github.com/wasmerio/wapm-cli/archive/0.4.3.tar.gz"
  sha256 "0a4057217a539a013549fd2bf3913bff28f0ec01d6606ebc278c2057c6e268a2"
  head "https://github.com/wasmerio/wapm-cli.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "0f587c4bd1ffeec8e37cd8eab7f093386d6589e0e05cc34e05f0be6d5819cbde" => :catalina
    sha256 "4ab3e6acac80d766cefd8f63becb7bde4f8d277db91fe281b6c2e6d359b440bf" => :mojave
    sha256 "ee2baae0bfbb0219146fc1789ea0e4f0b9d96d5ce27fb964fa2dabcb90eab019" => :high_sierra
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", "--locked", "--root", prefix, "--path", "."
  end

  test do
    help_first_line = shell_output("#{bin}/wapm -h 2> /dev/null").split("\n").first
    assert_equal "wapm-cli #{version}", help_first_line
  end
end
