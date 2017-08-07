require "language/go"

class DockerSlim < Formula
  desc "DockerSlim (docker-slim): Optimize and secure your Docker containers (free and open source)"
  homepage "https://github.com/docker-slim/docker-slim"
  url "https://github.com/cloudimmunity/docker-slim.git",
    :tag => "v1.13",
    :revision => "624f7a2022057184d982d8b74f035a9f518662b6"
  head "https://github.com/cloudimmunity/docker-slim.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "1bc440a00d8400a3d26b02e92b2c0fdc46ddfff42bd7013bd651ca3225b396d0" => :sierra
    sha256 "1323cd954e58c83e938f73a0c112691551b968dfcf49b2fffa303dde011b9a50" => :el_capitan
    sha256 "af72bd9da953e6fa7451c14b62cbe2f243d7d0eece1b7b8a4b58bd0416b724a9" => :yosemite
  end

  depends_on "go" => :build

  go_resource "github.com/mitchellh/gox" do
    url "https://github.com/mitchellh/gox.git",
      :revision => "6e9ee79eab7bb1b84155379b3f94ff9a87b344e4"
  end

  go_resource "github.com/mitchellh/iochan" do
    url "https://github.com/mitchellh/iochan.git",
      :revision => "87b45ffd0e9581375c491fef3d32130bb15c5bd7"
  end

  go_resource "github.com/cloudimmunity/go-dockerclientx" do
    url "https://github.com/cloudimmunity/go-dockerclientx.git",
      :revision => "77d597b1ae1d95af5721690ad0de88e70ae89fbc"
  end

  go_resource "github.com/cloudimmunity/pdiscover" do
    url "https://github.com/cloudimmunity/pdiscover.git",
      :revision => "f9d6e4e9b48c8b18879f7cb7f0857db624e04b58"
  end

  go_resource "github.com/cloudimmunity/system" do
    url "https://github.com/cloudimmunity/system.git",
      :revision => "139ed9afc107d5eaa3b966113acc78ebf6c8f28b"
  end

  go_resource "github.com/codegangsta/cli" do
    url "https://github.com/codegangsta/cli.git",
      :tag => "v1.19.1"
  end

  go_resource "github.com/dustin/go-humanize" do
    url "https://github.com/dustin/go-humanize.git",
      :revision => "259d2a102b871d17f30e3cd9881a642961a1e486"
  end

  go_resource "github.com/docker/go-connections" do
    url "https://github.com/docker/go-connections.git",
      :tag => "v0.2.1"
  end

  go_resource "github.com/franela/goreq" do
    url "https://github.com/franela/goreq.git",
      :revision => "b5b0f5eb2d16f20345cce0a544a75163579c0b00"
  end

  go_resource "github.com/go-mangos/mangos" do
    url "https://github.com/go-mangos/mangos.git",
      :revision => "e3181ec4a2a556d80619da0f841e35c2007733af"
  end

  go_resource "github.com/Sirupsen/logrus" do
    url "https://github.com/sirupsen/logrus.git",
      :tag => "v1.0.1"
  end

  def install
    ENV["GOPATH"] = buildpath

    contents = buildpath.children - [buildpath/".brew_home"]
    (buildpath/"src/github.com/cloudimmunity/docker-slim").install contents

    ENV.prepend_create_path "PATH", buildpath/"bin"

    Language::Go.stage_deps resources, buildpath/"src"

    cd "src/github.com/mitchellh/gox" do
      system "go", "install"
    end

    system "go", "install", "github.com/cloudimmunity/docker-slim/apps/docker-slim"

    bin.install "bin/docker-slim"
  end

  test do
    usage = <<EOUSAGE
NAME:
   docker-slim - optimize and secure your Docker containers!

USAGE:
   docker-slim [global options] command [command options] [arguments...]

VERSION:
   1.13

COMMANDS:
     info, i     Collects fat image information and reverse engineers its Dockerfile
     build, b    Collects fat image information and builds a slim image from it
     profile, p  Collects fat image information and generates a fat container report
     help, h     Shows a list of commands or help for one command

GLOBAL OPTIONS:
   --debug                enable debug logs
   --log value            log file to store logs
   --log-format value     set the format used by logs ('text' (default), or 'json') (default: "text")
   --tls                  use TLS
   --tls-verify           verify TLS
   --tls-cert-path value  path to TLS cert files
   --host value           Docker host address
   --help, -h             show help
   --version, -v          print the version
EOUSAGE
    assert_match usage, shell_output("#{bin}/docker-slim --help")
  end
end
