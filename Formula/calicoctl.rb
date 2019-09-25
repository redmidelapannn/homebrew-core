class Calicoctl < Formula
  desc "Calico CLI tool"
  homepage "https://www.projectcalico.org"
  url "https://github.com/projectcalico/calicoctl.git",
      :tag      => "v3.9.0",
      :revision => "ab93db3bc81fe069e3a6cce521f1956870adfb88"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "a063871ded7b8568ad305e64be5c7cc67c802a878f4c88d512b9cd326ec1e8a1" => :mojave
    sha256 "ae83823d19279046f66fd630e733d1f447170acf11e706da6a82e6046e1f2e5c" => :high_sierra
    sha256 "2ec92a83c51be14c79733d7c4a2ae519c9eced190dfe608b661171a1da2c19ab" => :sierra
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath

    dir = buildpath/"src/github.com/projectcalico/calicoctl"
    dir.install buildpath.children

    cd dir do
      commands = "github.com/projectcalico/calicoctl/calicoctl/commands"
      ldflags = "-X #{commands}.VERSION=#{stable.specs[:tag]} -X #{commands}.GIT_REVISION=#{stable.specs[:revision][0, 8]} -s -w"
      system "go", "build", "-v", "-o", "dist/calicoctl-darwin-amd64", "-ldflags", ldflags, "calicoctl/calicoctl.go"
      bin.install "dist/calicoctl-darwin-amd64" => "calicoctl"
      prefix.install_metafiles
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/calicoctl version", 1)
  end
end
