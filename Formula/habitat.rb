class Habitat < Formula
  desc "Tool to create automation for applications"
  homepage "https://www.habitat.sh/"
  url "https://api.bintray.com/content/habitat/stable/darwin/x86_64/hab-0.8.0-20160708205701-x86_64-darwin.zip?bt_package=hab-x86_64-darwin"
  version "0.8.0-20160708205701"
  sha256 "0641a60618a5944a4b0952a1f10aefe0bb344bcd044600f9df25ab5dfe301f66"
  bottle do
    cellar :any_skip_relocation
    sha256 "dec6d86f828e0c5ecf78f586ae78e7155f5a7bd73f2b86ca152d0c8e7fc4cbee" => :el_capitan
    sha256 "5a1a17327f87a021b5ca798dc0780fe781dd963ff2741d74dbe9edfaa1c95348" => :yosemite
    sha256 "c33fd3a65c79dee45b9551028f7dbffa3aeeaffa37e7e95b2555a5bd041bfae5" => :mavericks
  end

  def install
    bin.install "hab"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}hab --version 2>&1")
  end
end
