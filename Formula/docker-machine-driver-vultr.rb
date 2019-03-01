class DockerMachineDriverVultr < Formula
  desc "Docker Machine driver plugin for Vultr Cloud"
  homepage "https://github.com/janeczku/docker-machine-vultr"
  url "https://github.com/janeczku/docker-machine-vultr/archive/v1.4.0.tar.gz"
  sha256 "f69b1b33c7c73bea4ab1980fbf59b7ba546221d31229d03749edee24a1e7e8b5"
  head "https://github.com/janeczku/docker-machine-vultr.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 2
    sha256 "3545b9a0ceb91694a4f7dbecbe964de5bb1650b296d30273de09195eca2fe911" => :mojave
    sha256 "d42323158bbc1dae48713776b34822c18371e7f457d3f73d7718322351d6436d" => :high_sierra
    sha256 "4442e48b1ff7779dbc0c4f1442bf9557f9bad29a24e936734b50c8a19620a806" => :sierra
  end

  depends_on "go" => :build
  depends_on "docker-machine"

  def install
    ENV["GOPATH"] = buildpath
    (buildpath/"src/github.com/janeczku/docker-machine-vultr").install buildpath.children

    cd "src/github.com/janeczku/docker-machine-vultr" do
      system "make"
      bin.install "build/docker-machine-driver-vultr-v#{version}" => "docker-machine-driver-vultr"
      prefix.install_metafiles
    end
  end

  test do
    assert_match "--vultr-api-endpoint",
      shell_output("#{Formula["docker-machine"].bin}/docker-machine create --driver vultr -h")
  end
end
