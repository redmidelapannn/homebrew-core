require "language/go"

class Terraform < Formula
  desc "Tool to build, change, and version infrastructure"
  homepage "https://www.terraform.io/"
  url "https://github.com/hashicorp/terraform/archive/v0.6.16.tar.gz"
  sha256 "c84bae32a170d993982de9c537eac74f70601e7a667dc2ea9803b86e04b1221d"
  head "https://github.com/hashicorp/terraform.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "a020277762d02c8eb59e087bfd0fcb5ce15102d843e0474d8c6ca4e492ba827c" => :el_capitan
    sha256 "8922b0af49c230c6a1d4a97eb469ec0058c8e64b75284eff82dc90827bcd7e8f" => :yosemite
    sha256 "bbbfdb0b8c7525ad1e7f5f81d69862187e805502ab18e1fa8d206affe1b7c67d" => :mavericks
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    mkdir_p buildpath/"bin"
    ENV.append_path "PATH", buildpath/"bin"

    terrapath = buildpath/"src/github.com/hashicorp/terraform"
    terrapath.install Dir["*"]

    cd terrapath do
      ENV["XC_OS"] = "darwin"
      ENV["XC_ARCH"] = MacOS.prefer_64_bit? ? "amd64" : "386"
      system "make", "bin"
      bin.install Dir["bin/*"]
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
