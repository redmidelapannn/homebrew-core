class DockerDiff < Formula
  desc "Compare Docker images"
  homepage "https://github.com/moul/docker-diff"
  url "https://github.com/moul/docker-diff/archive/v1.0.tar.gz"
  sha256 "21826141f9161f66a14f38c617a7f9c459d34439c47daf7029ea7a8ec83dc8c2"
  head "https://github.com/moul/docker-diff.git"
  bottle do
    cellar :any_skip_relocation
    sha256 "9cda188d46395b537785e830cc0817364faaa611b59c9bed0d6e9dcf22e3bf15" => :sierra
    sha256 "9cda188d46395b537785e830cc0817364faaa611b59c9bed0d6e9dcf22e3bf15" => :el_capitan
    sha256 "9cda188d46395b537785e830cc0817364faaa611b59c9bed0d6e9dcf22e3bf15" => :yosemite
  end

  def install
    bin.install "docker-diff"
  end
  test do
    system "test", "-f", "#{bin}/docker-diff"
  end
end
