class DockerMachineIpconfig < Formula
  desc "Manipulate docker-machine network interface settings"
  homepage "https://github.com/fivestars/docker-machine-ipconfig"
  url "https://github.com/fivestars/docker-machine-ipconfig.git",
    :tag => "v1.0.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "01ab66396c7e688e2424d07b0cb67c74db01e81d4afbebc48159716649e68bdb" => :high_sierra
    sha256 "01ab66396c7e688e2424d07b0cb67c74db01e81d4afbebc48159716649e68bdb" => :sierra
    sha256 "01ab66396c7e688e2424d07b0cb67c74db01e81d4afbebc48159716649e68bdb" => :el_capitan
  end

  depends_on "docker-machine" => :recommended

  def install
    bin.install "docker-machine-ipconfig"
  end

  test do
    assert_match "Usage: docker-machine-ipconfig", shell_output(bin/"docker-machine-ipconfig --help")
  end
end
