class Iamy < Formula
  desc "AWS IAM import and export tool"
  homepage "https://github.com/99designs/iamy"
  url "https://github.com/99designs/iamy/archive/v2.1.1.tar.gz"
  sha256 "c23e061ab0ebe8009e2db27fef95d733490a5a76a4f7d54bd1323ab8faf2441a"
  head "https://github.com/99designs/iamy.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "eb8b630205490560e5bc85854aec5257052166f42f5501d8d95df0684b4f3576" => :high_sierra
    sha256 "826ea714f03220eb5dfbf0fc83a87de95e948ba6b8f739b6039a2be8d1907f09" => :sierra
    sha256 "0318cbb8e631beefa6ee8e6711e8b6a2f8b21d20f997c6d027f11190668f4061" => :el_capitan
  end

  depends_on "go" => :build
  depends_on "awscli"

  def install
    ENV["GOPATH"] = buildpath
    dir = buildpath/"src/github.com/99designs/iamy"
    dir.install buildpath.children
    cd dir do
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
