class Circleci < Formula
  desc "Enables you to reproduce the CircleCI environment locally"
  homepage "https://circleci.com/docs/2.0/local-cli/"
  # Updates should be pushed no more frequently than once per week.
  url "https://github.com/CircleCI-Public/circleci-cli.git",
      :tag      => "v0.1.6949",
      :revision => "d951526a5e43199a99eb395bb2ef9794a4027f2f"

  bottle do
    cellar :any_skip_relocation
    sha256 "efc5658b6ec2b13a7a919e56fcfe5e5a844f83ecc950b8d779820931a8aaea6a" => :catalina
    sha256 "c7bab0a83dea78e30ee437030b71f26a6f9c2d815bf03a6ea29f38f5093dfd30" => :mojave
    sha256 "f828047d1fdecee4d82e931c556a9f431231aabe1883084ad596af7d49a1a944" => :high_sierra
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
        -X github.com/CircleCI-Public/circleci-cli/cmd.PackageManager=homebrew
        -X github.com/CircleCI-Public/circleci-cli/version.Version=#{version}
        -X github.com/CircleCI-Public/circleci-cli/version.Commit=#{commit}
      ]
      system "make", "pack"
      system "go", "build", "-ldflags", ldflags.join(" "),
             "-o", bin/"circleci"
      prefix.install_metafiles
    end
  end

  test do
    # assert basic script execution
    assert_match /#{version}\+.{7}/, shell_output("#{bin}/circleci version").strip
    # assert script fails because 2.1 config is not supported for local builds
    (testpath/".circleci.yml").write("{version: 2.1}")
    output = shell_output("#{bin}/circleci build -c #{testpath}/.circleci.yml 2>&1", 255)
    assert_match "Local builds do not support that version at this time", output
    # assert update is not included in output of help meaning it was not included in the build
    assert_match "update      This command is unavailable on your platform", shell_output("#{bin}/circleci help")
    assert_match "`update` is not available because this tool was installed using `homebrew`.", shell_output("#{bin}/circleci update")
  end
end
