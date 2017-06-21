class Minishift < Formula
  desc "Runs a single-node OpenShift cluster inside a VM"
  homepage "https://minishift.io/"
  url "https://github.com/minishift/minishift/releases/download/v1.1.0/minishift-1.1.0-darwin-amd64.tgz"
  version "1.1.0"
  sha256 "6c516e11c8b69995df76e39100cda98906259ea5f5ceb860cac51a451bc39d0a"

  bottle do
    cellar :any_skip_relocation
    sha256 "2eba283745853ff6d321d83c53303a807b40f122e459cc73d819c7eb2776cb1b" => :sierra
    sha256 "ca21748d8e1d9aa43fe3aa9a198e745fc3481b4a0480b268b1c6d26bedcff18b" => :el_capitan
    sha256 "ca21748d8e1d9aa43fe3aa9a198e745fc3481b4a0480b268b1c6d26bedcff18b" => :yosemite
  end

  def install
    bin.install "minishift"
  end

  test do
    assert_equal "minishift v#{version}\n", shell_output("#{bin}/minishift version")
  end
end
