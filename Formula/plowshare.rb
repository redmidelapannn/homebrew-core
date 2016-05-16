class Plowshare < Formula
  desc "Download/upload tool for popular file sharing websites"
  homepage "https://github.com/mcrapet/plowshare"
  url "https://github.com/mcrapet/plowshare/archive/v2.1.4.tar.gz"
  sha256 "d6bb484fe63a8e9219a3f284a9ad21e260e2fc21aa004eedfcac86fb65e8c13e"

  bottle do
    cellar :any_skip_relocation
    sha256 "bf4bfa8d04e238237bb823360685d8d95beabd8858a46c45a11e8cc21306dec7" => :el_capitan
    sha256 "b4aed9a8ee2b569f11c67e5f484e31f1fb692835fde4e9bfe3cbbcad1e8b4cd4" => :yosemite
    sha256 "7276e30e64024e030ef6b7cf2ea5feac203c63e4c44087eca35f578e0dcb9671" => :mavericks
  end

  depends_on "aview"
  depends_on "bash"
  depends_on "coreutils"
  depends_on "gnu-sed"
  depends_on "imagemagick" => "with-x11"
  depends_on "recode"
  depends_on "spidermonkey"

  def install
    system "make", "install", "patch_gnused", "GNU_SED=#{HOMEBREW_PREFIX}/bin/gsed", "PREFIX=#{prefix}"
  end
end
