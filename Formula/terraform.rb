require "language/go"

class Terraform < Formula
  desc "Tool to build, change, and version infrastructure"
  homepage "https://www.terraform.io/"
  url "https://github.com/hashicorp/terraform/archive/v0.9.0.tar.gz"
  sha256 "5c0d7f0b20fde05b0cf556508740468553d53bd26d5d67898a4b9ad46ebc1028"
  head "https://github.com/hashicorp/terraform.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "5a7099d14502f309093ba33240fb67c44233b7766bb4ff01404eb7679aab8b7a" => :sierra
    sha256 "b11a5f5dc1036400921af35eb4975d66ea51c8889cdca828d4f161caeb1d0972" => :el_capitan
    sha256 "f075b4005d08bca00129e17989fc7e098db46b5a81a83c2c375c335c389162b9" => :yosemite
  end

  depends_on "go" => :build

  conflicts_with "tfenv", :because => "tfenv symlinks terraform binaries"

  go_resource "github.com/mitchellh/gox" do
    url "https://github.com/mitchellh/gox.git",
        :revision => "c9740af9c6574448fd48eb30a71f964014c7a837"
  end

  go_resource "github.com/mitchellh/iochan" do
    url "https://github.com/mitchellh/iochan.git",
        :revision => "87b45ffd0e9581375c491fef3d32130bb15c5bd7"
  end

  go_resource "github.com/kisielk/errcheck" do
    url "https://github.com/kisielk/errcheck.git",
        :revision => "9c1292e1c962175f76516859f4a88aabd86dc495"
  end

  go_resource "github.com/kisielk/gotool" do
    url "https://github.com/kisielk/gotool.git",
        :revision => "5e136deb9b893bbe6c8f23236ff4378b7a8a0dbb"
  end

  go_resource "golang.org/x/tools" do
    url "https://go.googlesource.com/tools.git",
        :revision => "26c35b4dcf6dfcb924e26828ed9f4d028c5ce05a"
  end

  # consul tests failing on 0.9.0 tag
  # upstream issue: https://github.com/hashicorp/terraform/issues/12731
  patch do
    url "https://github.com/hashicorp/terraform/commit/7f9a57db1d64a7a5e6e56b4144a363ce47179408.patch"
    sha256 "15c02bf7b70dd49d2c2f34f42f121df105122a2271f819d78a223c5f0dd382f1"
  end

  def install
    ENV["GOPATH"] = buildpath
    # For the gox buildtool used by terraform, which doesn't need to
    # get installed permanently
    ENV.append_path "PATH", buildpath

    dir = buildpath/"src/github.com/hashicorp/terraform"
    dir.install buildpath.children - [buildpath/".brew_home"]
    Language::Go.stage_deps resources, buildpath/"src"

    cd "src/github.com/mitchellh/gox" do
      system "go", "build"
      buildpath.install "gox"
    end

    cd "src/golang.org/x/tools/cmd/stringer" do
      ENV.deparallelize { system "go", "build" }
      buildpath.install "stringer"
    end

    cd "src/github.com/kisielk/errcheck" do
      system "go", "build"
      buildpath.install "errcheck"
    end

    cd dir do
      # v0.6.12 - source contains tests which fail if these environment variables are set locally.
      ENV.delete "AWS_ACCESS_KEY"
      ENV.delete "AWS_SECRET_KEY"

      arch = MacOS.prefer_64_bit? ? "amd64" : "386"
      ENV["XC_OS"] = "darwin"
      ENV["XC_ARCH"] = arch
      system "make", "test", "vet", "bin"

      # Install release binary
      bin.install "pkg/darwin_#{arch}/terraform"
      zsh_completion.install "contrib/zsh-completion/_terraform"
    end
  end

  test do
    minimal = testpath/"minimal.tf"
    minimal.write <<-EOS.undent
      variable "aws_region" {
          default = "us-west-2"
      }

      variable "aws_amis" {
          default = {
              eu-west-1 = "ami-b1cf19c6"
              us-east-1 = "ami-de7ab6b6"
              us-west-1 = "ami-3f75767a"
              us-west-2 = "ami-21f78e11"
          }
      }

      # Specify the provider and access details
      provider "aws" {
          access_key = "this_is_a_fake_access"
          secret_key = "this_is_a_fake_secret"
          region = "${var.aws_region}"
      }

      resource "aws_instance" "web" {
        instance_type = "m1.small"
        ami = "${lookup(var.aws_amis, var.aws_region)}"
        count = 4
      }
    EOS
    system "#{bin}/terraform", "graph", testpath
  end
end
