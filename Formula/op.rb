class Op < Formula
  desc "CLI for 1password.com"
  homepage "https://support.1password.com/command-line-getting-started/"
  url "https://cache.agilebits.com/dist/1P/op/pkg/v0.2.1/op_darwin_amd64_v0.2.1.zip"
  sha256 "fd15c2c0e429623e3d0bff17f7f94867cd5d8b55d10f69076c2ec277da755d77"

  bottle do
    cellar :any_skip_relocation
    sha256 "6a1ae47e05cfcb1946ae4b66190bdfeb8a9fec041494ae6cc5d90191d11e2202" => :high_sierra
    sha256 "6a1ae47e05cfcb1946ae4b66190bdfeb8a9fec041494ae6cc5d90191d11e2202" => :sierra
    sha256 "6a1ae47e05cfcb1946ae4b66190bdfeb8a9fec041494ae6cc5d90191d11e2202" => :el_capitan
  end

  def install
    bin.install "op"
  end

  test do
    # 'op -version' exits with status 1, rather than 0
    assert_match version.to_s, shell_output("#{bin}/op --version", 1)
  end
end
