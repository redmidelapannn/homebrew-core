class Circleci < Formula
  desc "Enables you to reproduce the CircleCI environment locally"
  homepage "https://circleci.com/docs/2.0/local-cli/"
  # Updates should be pushed no more frequently than once per week.
  url "https://github.com/CircleCI-Public/circleci-cli.git",
      :tag      => "v0.1.5389",
      :revision => "4379bab5169f609898214b717c313f9943fdbe41"

  bottle do
    cellar :any_skip_relocation
    sha256 "cb098141ca6c19e62092f6a1e760ca44f3b31985ee199539d53b20459f48a95f" => :mojave
    sha256 "2af21634ff24696347a6e9f6f371045a126b4b080dd605d20c11fb3f2067a346" => :high_sierra
    sha256 "580f3ec251396bbb558c64e3062cd0a0d635cb2ce370d2eede30f6eec9848da1" => :sierra
  end

  depends_on "go" => :build

  resource "packr" do
    url "https://github.com/gobuffalo/packr/archive/v2.0.1.tar.gz"
    sha256 "cc0488e99faeda4cf56631666175335e1cce021746972ce84b8a3083aa88622f"
  end

  def install
    ENV["GOPATH"] = buildpath
    ENV["GO111MODULE"] = "on"

    dir = buildpath/"src/github.com/CircleCI-Public/circleci-cli"
    dir.install buildpath.children

    cd dir do
      resource("packr").stage do
        system "go", "install", "./packr"

        # TODO: Debug why this isn't compiling data files correctly
        #
        # Refer to packr by its absolute path, in case GOPATH isn't in the user's path
        system buildpath/"bin/packr"
        system buildpath/"bin/packr", "build"
      end
      commit = Utils.popen_read("git rev-parse --short HEAD").chomp
      ldflags = %W[
        -s -w
        -X github.com/CircleCI-Public/circleci-cli/cmd.PackageManager=homebrew
        -X github.com/CircleCI-Public/circleci-cli/version.Version=#{version}
        -X github.com/CircleCI-Public/circleci-cli/version.Commit=#{commit}
      ]
      system buildpath/"bin/packr", "build", "-ldflags", ldflags.join(" "),
             "-o", bin/"circleci"
      prefix.install_metafiles
    end
  end

  test do
    puts "pre-test"
    puts shell_output("whoami")
    shell_output("#{bin}/circleci version")
    puts "test 1"
    # assert basic script execution
    assert_match /#{version}\+.{7}/, shell_output("#{bin}/circleci version").strip
    puts "test 2"
    # assert script fails because 2.1 config is not supported for local builds
    (testpath/".circleci.yml").write("{version: 2.1}")
    output = shell_output("#{bin}/circleci build -c #{testpath}/.circleci.yml 2>&1", 255)
    assert_match "Local builds do not support that version at this time", output
    # assert update is not included in output of help meaning it was not included in the build
    assert_match "update      This command is unavailable on your platform", shell_output("#{bin}/circleci help")
    assert_match "`update` is not available because this tool was installed using `homebrew`.", shell_output("#{bin}/circleci update")
  end
end
