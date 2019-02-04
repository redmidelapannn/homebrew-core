require "language/go"

class TerraformInventory < Formula
  desc "Terraform State → Ansible Dynamic Inventory"
  homepage "https://github.com/adammck/terraform-inventory"
  url "https://github.com/adammck/terraform-inventory/archive/v0.6.1.tar.gz"
  sha256 "9cdcbc5ce4247b72bb72923d01246f51252a88908d760d766daeac51dd8feed9"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "907ed35425cbd31c9e71eb93059484bdf1f0983a359dee0d32ce4a1b0cd8bd72" => :mojave
    sha256 "728a0cbfe7421c634c7488fce9d08f3405e421d0b4eeb9c21492f7bc8546ace4" => :high_sierra
    sha256 "88066750ed6f5e4fcca430e9feb931ce15a9ef3889ac583d06e36d7b736bbab1" => :sierra
  end

  head do
    url "https://github.com/adammck/terraform-inventory.git"

    go_resource "github.com/adammck/venv" do
      url "https://github.com/adammck/venv.git",
          :revision => "8a9c907a37d36a8f34fa1c5b81aaf80c2554a306"
    end

    go_resource "github.com/blang/vfs" do
      url "https://github.com/blang/vfs.git",
          :revision => "2c3e2278e174a74f31ff8bf6f47b43ecb358a870"
    end
  end

  depends_on "go" => :build

  go_resource "github.com/stretchr/testify" do
    url "https://github.com/stretchr/testify.git",
        :revision => "f390dcf405f7b83c997eac1b06768bb9f44dec18"
  end

  def install
    ENV["GOPATH"] = buildpath

    mkdir_p buildpath/"src/github.com/adammck/"
    ln_sf buildpath, buildpath/"src/github.com/adammck/terraform-inventory"
    Language::Go.stage_deps resources, buildpath/"src"

    system "go", "build", "-o", bin/"terraform-inventory", "-ldflags", "-X main.build_version='#{version}'"
  end

  test do
    example = <<~EOS
      {
          "version": 1,
          "serial": 1,
          "modules": [
              {
                  "path": [
                      "root"
                  ],
                  "outputs": {},
                  "resources": {
                      "aws_instance.example_instance": {
                          "type": "aws_instance",
                          "primary": {
                              "id": "i-12345678",
                              "attributes": {
                                  "public_ip": "1.2.3.4"
                              },
                              "meta": {
                                  "schema_version": "1"
                              }
                          }
                      }
                  }
              }
          ]
      }
    EOS
    (testpath/"example.tfstate").write(example)
    assert_match(/example_instance/, shell_output("#{bin}/terraform-inventory --list example.tfstate"))
  end
end
