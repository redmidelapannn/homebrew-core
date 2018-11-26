require "language/go"

class Ghq < Formula
  desc "Remote repository management made easy"
  homepage "https://github.com/motemen/ghq"
  url "https://github.com/motemen/ghq/archive/v0.9.0.tar.gz"
  sha256 "c5b9ff71ab533a2789da27368603852a3969c5cf8137b12b95e1bcbdaa816cf6"

  bottle do
    cellar :any_skip_relocation
    sha256 "6815e9b811ffa9a66a5070402d9573267665b98f8456e4ce52565cc4e4f1097e" => :mojave
    sha256 "86c2b24bf1c15d1c733b44f068f3b7110421ebe82613568c62ad6bd80da58324" => :high_sierra
    sha256 "76d8fb7cc46835159a58c8662590755c26a05c4542235d027e0d366f3e60c276" => :sierra
  end

  depends_on "go" => :build

  go_resource "github.com/daviddengcn/go-colortext" do
    url "https://github.com/daviddengcn/go-colortext.git",
        :revision => "805cee6e0d43c72ba1d4e3275965ff41e0da068a"
  end

  go_resource "github.com/mitchellh/go-homedir" do
    url "https://github.com/mitchellh/go-homedir.git",
        :revision => "b8bc1bf767474819792c23f32d8286a45736f1c6"
  end

  go_resource "github.com/motemen/go-colorine" do
    url "https://github.com/motemen/go-colorine.git",
        :revision => "49ff36b8fa42db28092361cd20dcefd0b03b1472"
  end

  go_resource "github.com/urfave/cli" do
    url "https://github.com/urfave/cli.git",
        :revision => "f017f86fccc5a039a98f23311f34fdf78b014f78"
  end

  def install
    mkdir_p buildpath/"src/github.com/motemen/"
    ln_s buildpath, buildpath/"src/github.com/motemen/ghq"
    ENV["GOPATH"] = buildpath
    Language::Go.stage_deps resources, buildpath/"src"

    system "go", "build", "-ldflags", "-X main.Version=#{version}",
                          "-o", bin/"ghq"
    zsh_completion.install "zsh/_ghq"
  end

  test do
    assert_match "#{testpath}/.ghq", shell_output("#{bin}/ghq root")
  end
end
