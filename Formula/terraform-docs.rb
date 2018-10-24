class TerraformDocs < Formula
  desc "Tool to generate documentation from Terraform modules"
  homepage "https://github.com/segmentio/terraform-docs"
  url "https://github.com/segmentio/terraform-docs/archive/v0.5.0.tar.gz"
  sha256 "310f4b13585d6ae59687bf20763af5e27930dd30673af24b7297d5fe1fe9df22"

  bottle do
    cellar :any_skip_relocation
    sha256 "e9b99761071619ce26d6498a4ec4eb0a17ec4f4c831e1419c6316680f16f8b7f" => :mojave
    sha256 "d081aee7e025c3bee84bcf629b2df7c713ad72be54e4d4dfac2a8c5631a65ba3" => :high_sierra
    sha256 "6045d0586922a86846051b8b0736d8f9b7e9175e6758df6edb98465f46f0b637" => :sierra
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    dir = buildpath/"src/github.com/segmentio/terraform-docs"
    dir.install buildpath.children

    cd dir do
      system "make", "build-darwin-amd64"
      bin.install "bin/darwin-amd64/terraform-docs"
      prefix.install_metafiles
    end
  end

  test do
    (testpath/"main.tf").write <<~EOS
      /**
       * Module usage:
       *
       *      module "foo" {
       *        source = "github.com/foo/baz"
       *        subnet_ids = "${join(",", subnet.*.id)}"
       *      }
       */

      variable "subnet_ids" {
        description = "a comma-separated list of subnet IDs"
      }

      variable "security_group_ids" {
        default = "sg-a, sg-b"
      }

      variable "amis" {
        default = {
          "us-east-1" = "ami-8f7687e2"
          "us-west-1" = "ami-bb473cdb"
          "us-west-2" = "ami-84b44de4"
          "eu-west-1" = "ami-4e6ffe3d"
          "eu-central-1" = "ami-b0cc23df"
          "ap-northeast-1" = "ami-095dbf68"
          "ap-southeast-1" = "ami-cf03d2ac"
          "ap-southeast-2" = "ami-697a540a"
        }
      }

      // The VPC ID.
      output "vpc_id" {
        value = "vpc-5c1f55fd"
      }
    EOS
    system "#{bin}/terraform-docs", "json", testpath
  end
end
