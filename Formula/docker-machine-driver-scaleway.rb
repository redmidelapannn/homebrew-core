require "language/go"

class DockerMachineDriverScaleway < Formula
  desc "Docker Machine driver for Scaleway"
  homepage "https://github.com/scaleway/docker-machine-driver-scaleway/"
  url "https://github.com/scaleway/docker-machine-driver-scaleway/archive/v1.0.1.tar.gz"
  sha256 "90caba19fa78bd5c6e01c0696ff37eb9d877cb252ae37dacc63ffde86a3cbe7a"

  head "https://github.com/scaleway/docker-machine-driver-scaleway.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "2677be89afa81d07c852b0ef3bddd19173501ae4ae3dcc1629936c77bfaa3ed2" => :el_capitan
    sha256 "35e6dfea50b39aa8f2edb979b295aa83f9f82350c05439d4cf6c78ba6a4bc489" => :yosemite
    sha256 "e12f0c1f36c2c54b5fd4a1d07806367cf57d133086d82274c7dd9457dc1bdbd2" => :mavericks
  end

  depends_on "go" => :build
  depends_on "docker-machine" => :recommended

  def install
    ENV["GOPATH"] = buildpath
    path = buildpath/"src/github.com/scaleway/docker-machine-driver-scaleway"
    path.install Dir["{*,.git,.gitignore}"]

    cd path do
      system "go", "build", "-o", "#{bin}/docker-machine-driver-scaleway", "./main.go"
    end
  end

  test do
    output = shell_output("#{Formula["docker-machine"].bin}/docker-machine create --driver scaleway -h")
    assert_match "scaleway-name", output
  end
end
