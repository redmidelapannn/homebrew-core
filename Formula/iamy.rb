class Iamy < Formula
  desc "AWS IAM import and export tool"
  homepage "https://github.com/99designs/iamy"
  url "https://github.com/99designs/iamy/archive/v2.3.2.tar.gz"
  sha256 "66d44dd6af485b2b003b0aa1c8dcd799f7bae934f1ce1efb7e5d5f6cfe7f8bf2"
  head "https://github.com/99designs/iamy.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "feeb95e73dbc9fcb6e0fd4c2fe45121ee3d822a59415027a30c78f39c91f6aaf" => :mojave
    sha256 "34b6dd775bf3a2df0dae0c9cd92615be7a88ed2851131fe9ad5a25caf35f85a2" => :high_sierra
    sha256 "424afb274564c86643234ce74b786bff399bff58b0fd6b7ea717bf0fe64f243d" => :sierra
  end

  depends_on "go" => :build
  depends_on "awscli"

  def install
    ENV["GOPATH"] = buildpath
    src = buildpath/"src/github.com/99designs/iamy"
    src.install buildpath.children
    src.cd do
      system "go", "build", "-o", bin/"iamy", "-ldflags",
             "-X main.Version=v#{version}"
      prefix.install_metafiles
    end
  end

  test do
    ENV.delete "AWS_ACCESS_KEY"
    ENV.delete "AWS_SECRET_KEY"
    output = shell_output("#{bin}/iamy pull 2>&1", 1)
    assert_match "Can't determine the AWS account", output
  end
end
