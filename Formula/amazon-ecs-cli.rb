class AmazonEcsCli < Formula
  desc "CLI for Amazon ECS to manage clusters and tasks for development"
  homepage "https://aws.amazon.com/ecs"
  url "https://github.com/aws/amazon-ecs-cli/archive/v0.6.6.tar.gz"
  sha256 "0111a170ca5a15812c88edf0721d7c02fa76def882f46547595ae40d29041a28"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "5abd9ec48fe90c974f64a9067bbcdea56f9edb260c636df4aac53e8f4b4c20b5" => :high_sierra
    sha256 "90f9aa42bee517f56344c1444fe748a8ce7bbecb4eff8bcde4334c5b72695cff" => :sierra
    sha256 "b581b2d4fb18e14e48094c57d274c228ab078e23a131ac8b04077efe5ba8c7f5" => :el_capitan
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    (buildpath/"src/github.com/aws/amazon-ecs-cli").install buildpath.children
    cd "src/github.com/aws/amazon-ecs-cli" do
      system "make", "build"
      system "make", "test"
      bin.install "bin/local/ecs-cli"
      prefix.install_metafiles
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ecs-cli -v")
  end
end
