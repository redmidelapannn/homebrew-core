class Boilr < Formula
  desc "Boilerplate template manager that generates files from template repo"
  homepage "https://github.com/tmrts/boilr"
  url "https://github.com/tmrts/boilr/releases/download/0.3.0/boilr-0.3.0-darwin_amd64.tgz"
  version "0.3.0"
  sha256 "81c135073310adbfbfa1b46fabb8467c26e08053340491d604ee9bec886c18d8"

  bottle do
    cellar :any_skip_relocation
    sha256 "a95a142ae0e33da27edf80c1d5a85f23978435af16cc527405ffa935db8de1e1" => :high_sierra
    sha256 "a95a142ae0e33da27edf80c1d5a85f23978435af16cc527405ffa935db8de1e1" => :sierra
    sha256 "a95a142ae0e33da27edf80c1d5a85f23978435af16cc527405ffa935db8de1e1" => :el_capitan
  end

  def install
    bin.install "boilr"
  end

  test do
    system "#{bin}/boilr", "--help"
  end
end
