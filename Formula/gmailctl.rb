class Gmailctl < Formula
  desc "Declarative configuration for Gmail filters"
  homepage "https://github.com/mbrt/gmailctl"
  url "https://github.com/mbrt/gmailctl/archive/v0.6.0.tar.gz"
  sha256 "e188d5d18ac84ca86c94fb2b90d219ae3bea1e1ddee1966fae904c93bf27f233"

  bottle do
    cellar :any_skip_relocation
    sha256 "0dafaab299749fb4e0756dfe02a68d8393bf9c39b041d3778b9245233b6a7a81" => :catalina
    sha256 "d34d390cea833e696c31da94cdb04bcefd4832f48eabb1c50fee4b07fd05374b" => :mojave
    sha256 "e1955f05c43db784360cf07abcbb066fc15809b3ed4134a734aa9593d4bb8501" => :high_sierra
  end

  depends_on "go" => :build

  def install
    system "go", "build", "-ldflags", "-s -w -X main.version=#{version}", *std_go_args, "cmd/gmailctl/main.go"
  end

  test do
    assert_includes shell_output("#{bin}/gmailctl init"), "The credentials are not initialized"
  end
end
