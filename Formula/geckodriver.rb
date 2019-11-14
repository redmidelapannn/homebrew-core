class Geckodriver < Formula
  desc "WebDriver <-> Marionette proxy"
  homepage "https://github.com/mozilla/geckodriver"
  # Get the commit id for stable releases from https://github.com/mozilla/geckodriver/releases
  url "https://hg.mozilla.org/mozilla-central/archive/e9783a644016aa9b317887076618425586730d73.zip/testing/"
  version "0.26.0"
  sha256 "89f20b2d492b44b40ee049d0f0d4d91c52758b74dd7b5c7acad89a88ca1f177e"
  head "https://hg.mozilla.org/mozilla-central/", :using => :hg

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "3a8fbe4b890e32c37c1f54606877fc9a19dc0ca73cd869dc85dce124736bd23a" => :catalina
    sha256 "3122c954db12b65b32a431b93e45236b0d04ccf9631a3b36a708b6b78c0db373" => :mojave
    sha256 "503bd26e7fc9e55d5a74fae22e5c391b4cd1f14bd9785721e430b9f515afc639" => :high_sierra
  end

  depends_on "rust" => :build

  def install
    cd "testing/geckodriver" do
      system "cargo", "install", "--locked", "--root", prefix, "--path", "."
    end
    bin.install_symlink bin/"geckodriver" => "wires"
  end

  test do
    system bin/"geckodriver", "--help"
  end
end
