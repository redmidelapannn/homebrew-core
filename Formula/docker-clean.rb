class DockerClean < Formula
  desc "Script cleans Docker containers, images, networks, and volumes."
  homepage "https://github.com/ZZROTDesign/docker-clean"
  url "https://github.com/ZZROTDesign/docker-clean/archive/v2.0.3.tar.gz"
  sha256 "a2e1923fe2862ca2487e39000c68cba900711b768a8920dd1b1275a2fa0e6789"

  bottle do
    cellar :any_skip_relocation
    sha256 "8a2aeabf9224c03cdf69263aa8dccb9593673113ebd0ecba2259831e948ccee2" => :el_capitan
    sha256 "4b7024c5255439a7f410a7380d2739b8293390cbac6d1b951ea4170d91defff9" => :yosemite
    sha256 "ac33fb663653ca09c878cfc51595bb1465324a6385065624822432d518e81edc" => :mavericks
  end

  def install
    bin.install "docker-clean"
  end

  test do
    system "#{bin}/docker-clean", "--help"
  end
end
