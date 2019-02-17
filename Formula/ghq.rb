require "language/go"

class Ghq < Formula
  desc "Remote repository management made easy"
  homepage "https://github.com/motemen/ghq"
  url "https://github.com/motemen/ghq/archive/v0.9.0.tar.gz"
  sha256 "c5b9ff71ab533a2789da27368603852a3969c5cf8137b12b95e1bcbdaa816cf6"

  bottle do
    cellar :any_skip_relocation
    sha256 "7ee467aeee846b26298f4f8d7155cf6388ea891126ddd65ebb46fed1c8244cc1" => :mojave
    sha256 "6103f3eac6415c69a9c25604b4b18a9b2af76e7aa5ce84fa25f5c34843764cfb" => :high_sierra
    sha256 "2c2cb4ddf9feb4e0fdbce31fd6c2338c4ad6d234a24327dd37f2b35f983d9aa2" => :sierra
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
