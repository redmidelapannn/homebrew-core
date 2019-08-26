class EnvkeyFetch < Formula
  desc "Give it an ENVKEY, get back decrypted config as json"
  homepage "https://www.envkey.com"
  url "https://github.com/envkey/envkey-fetch/archive/v1.2.8.tar.gz"
  sha256 "4d1f55ba8d1c024ddc49752979439d035beb890ddd1fe8b40805aa048c5a5bee"
  bottle do
    cellar :any_skip_relocation
    sha256 "dca9b55b4d747ab73674ac514dadc02f4ddf4de483e9fd827b12b2d9057bf10a" => :mojave
    sha256 "c24aed6ef4d400bece1267f34e46098d5b9b1e057e3c2d53300b8391649dc8ec" => :high_sierra
    sha256 "ac31d4fee6d971b39fbf44781eec815883029f5473b4e73fc016ece09fd993d5" => :sierra
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath/"src"
    ENV["GO111MODULE"] = "on"

    system "go", "build", "-o", "envkey-fetch", "main.go"

    bin.install "envkey-fetch"
  end

  test do
    shell_output "#{bin}/envkey-fetch"
    shell_output "#{bin}/envkey-fetch 000", 1
  end
end
