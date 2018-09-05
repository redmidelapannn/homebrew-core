class Circleci < Formula
  desc "Enables you to reproduce the CircleCI environment locally"
  homepage "https://circleci.com/docs/2.0/local-cli/"
  # Updates should be pushed no more frequently than once per week.
  url "https://github.com/CircleCI-Public/circleci-cli.git",
      :tag => "v0.1.2045",
      :revision => "8f1ad369dfec21b9b127554dc644f2f488938c06"
  revision 1

  bottle do
    cellar :any_skip_relocation
    sha256 "dd8aa7ef76c847913337df0f0897f29da7bfd6a670bc4efdc7ac2ac0b68c1bf9" => :mojave
    sha256 "823e46ed0fd1f77042ed26435f416e3ebb950bb6fb4677e8e2a8641ffb58d94b" => :high_sierra
    sha256 "6f3365d62162f6fbcc8bea418221a6abe4569ae2d38b8491427447cf9ec8da36" => :sierra
    sha256 "fe90c26fcddf317a372ff073972eef92e11975cb8c32bd958f9f8fd6652c3d1c" => :el_capitan
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    dir = buildpath/"src/github.com/CircleCI-Public/circleci-cli"
    dir.install buildpath.children

    cd dir do
      commit = Utils.popen_read("git rev-parse --short HEAD").chomp
      ldflags = %W[
        -s -w
        -X github.com/CircleCI-Public/circleci-cli/version.Version=#{version}
        -X github.com/CircleCI-Public/circleci-cli/version.Commit=#{commit}
      ]
      system "go", "build", "-ldflags", ldflags.join(" "),
             "-o", bin/"circleci"
      prefix.install_metafiles
    end
  end

  test do
    # assert basic script execution
    assert_match /#{version}\+.{7}/, shell_output("#{bin}/circleci version").strip
    # assert script fails for missing docker (docker not on homebrew CI servers)
    output = shell_output("#{bin}/circleci build 2>&1", 255)
    assert_match "failed to pull latest docker image", output
  end
end
