class Calicoctl < Formula
  desc "Calico CLI tool"
  homepage "https://www.projectcalico.org"
  url "https://github.com/projectcalico/calicoctl.git",
      :tag      => "v3.13.2",
      :revision => "eb796e31bcbfb42af3c2470bd23826f630d03ab5"

  bottle do
    cellar :any_skip_relocation
    sha256 "0d5d851a4ee2e3eb1137dcef09df87b0899a7bae99f77c34f5582f717e081a62" => :catalina
    sha256 "be43489309d3c4d2b68e8380b4b5a6f6ee822b9bf87876eea70e83858789ca1b" => :mojave
    sha256 "d747c0f3a405bbe1d562c7b898c7ae335c2bc43fd9909c57ef94b50739eb5e4c" => :high_sierra
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath

    dir = buildpath/"src/github.com/projectcalico/calicoctl"
    dir.install buildpath.children

    cd dir do
      commands = "github.com/projectcalico/calicoctl/calicoctl/commands"
      system "go", "build", "-v", "-o", "dist/calicoctl-darwin-amd64",
                            "-ldflags", "-X #{commands}.VERSION=#{stable.specs[:tag]} " \
                                        "-X #{commands}.GIT_REVISION=#{stable.specs[:revision][0, 8]} " \
                                        "-s -w",
                            "calicoctl/calicoctl.go"
      bin.install "dist/calicoctl-darwin-amd64" => "calicoctl"
      prefix.install_metafiles
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/calicoctl version", 1)
  end
end
