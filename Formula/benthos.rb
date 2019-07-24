class Benthos < Formula
  desc "Stream processor for mundane tasks written in Go"
  homepage "https://www.benthos.dev"
  url "https://github.com/Jeffail/benthos/archive/v2.9.3.tar.gz"
  sha256 "40c8e53081ce6ea115dad574769f74b0cd7de467ec4f2212747d867bb10e96bc"

  bottle do
    cellar :any_skip_relocation
    sha256 "cc6aa1838eaa9b87f1bcddb61f50215530a15da54790c9202dab7443daeaec8a" => :mojave
    sha256 "1e603bc78c0ee609998d9e665db3667f18f969f84b62f6e9e243083bb93927e1" => :high_sierra
    sha256 "a96a0b92e6f17e31f4a1c14d67a22adf951615796c4e05d9b2ec1d242d5add47" => :sierra
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    ENV["GO111MODULE"] = "on"

    src = buildpath/"src/github.com/Jeffail/benthos"
    src.install buildpath.children
    src.cd do
      system "make", "VERSION=2.9.3"
      bin.install "target/bin/benthos"
    end
  end

  test do
    benthos_version = shell_output("#{bin}/benthos --version | sed -nEe '/Version:/p'")
    assert_match "Version: #{version}", benthos_version.strip
  end
end