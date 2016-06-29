require "language/go"

class Ghq < Formula
  desc "Remote repository management made easy"
  homepage "https://github.com/motemen/ghq"

  stable do
    url "https://github.com/motemen/ghq/archive/v0.7.4.tar.gz"
    sha256 "f6e79a7efec2cc11dd8489ae31619de85f15b588158d663256bc9fd45aca6a5d"

    go_resource "github.com/codegangsta/cli" do
      url "https://github.com/codegangsta/cli.git", :revision => "aca5b047ed14d17224157c3434ea93bf6cdaadee"
    end
  end

  bottle do
    cellar :any_skip_relocation
    revision 1
    sha256 "26bd5d47b74bf2538c1a68ad13645977ae9a35de2589f65d8b17c3d16f31da36" => :el_capitan
    sha256 "228c6c3cbc6d9835eba660f35a2fcfbe090bbdee57c69a4cbdd1f558ada7f9a9" => :yosemite
    sha256 "6747375ff6e065f7b01601f132f2a214f0c1c83d2f7e7aaeb23a0a584256f636" => :mavericks
  end

  head do
    url "https://github.com/motemen/ghq.git"

    go_resource "github.com/codegangsta/cli" do
      url "https://github.com/codegangsta/cli.git", :revision => "1efa31f08b9333f1bd4882d61f9d668a70cd902e"
    end
  end

  option "without-completions", "Disable zsh completions"

  depends_on "go" => :build

  go_resource "github.com/mitchellh/go-homedir" do
    url "https://github.com/mitchellh/go-homedir.git", :revision => "981ab348d865cf048eb7d17e78ac7192632d8415"
  end

  go_resource "github.com/motemen/go-colorine" do
    url "https://github.com/motemen/go-colorine.git", :revision => "49ff36b8fa42db28092361cd20dcefd0b03b1472"
  end

  go_resource "github.com/daviddengcn/go-colortext" do
    url "https://github.com/daviddengcn/go-colortext.git", :revision => "3b18c8575a432453d41fdafb340099fff5bba2f7"
  end

  def install
    mkdir_p "#{buildpath}/src/github.com/motemen/"
    ln_s buildpath, "#{buildpath}/src/github.com/motemen/ghq"
    ENV["GOPATH"] = buildpath
    ENV.append_path "PATH", "#{ENV["GOPATH"]}/bin"
    Language::Go.stage_deps resources, buildpath/"src"

    system "go", "build", "-ldflags", "-X main.Version #{version}", "-o", "ghq"
    bin.install "ghq"

    if build.with? "completions"
      zsh_completion.install "zsh/_ghq"
    end
  end

  test do
    assert_match "#{testpath}/.ghq", shell_output("#{bin}/ghq root")
  end
end
