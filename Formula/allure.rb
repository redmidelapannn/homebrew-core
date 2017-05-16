class Allure < Formula
  desc "Flexible lightweight test report tool"
  homepage "https://github.com/allure-framework"
  url "https://dl.bintray.com/qameta/generic/io/qameta/allure/allure/2.0.1/allure-2.0.1.tgz"
  sha256 "315f2a9e963ce6293075149b15ed11423ac3709adb03658d1b16ed59bafcaa6e"

  bottle do
    cellar :any_skip_relocation
    sha256 "7a50c61453abe2d4abd444e41dd1e25861760f1465b1d59d61ed422c27f8de1f" => :sierra
    sha256 "8220457ca83cb4c7e83e76817e9eb5305a514f85548999a661ad5593ce68ada5" => :el_capitan
    sha256 "8220457ca83cb4c7e83e76817e9eb5305a514f85548999a661ad5593ce68ada5" => :yosemite
  end

  depends_on :java => "1.8"

  def install
    # Remove all windows files
    rm_f Dir["bin/*.bat"]

    prefix.install_metafiles
    libexec.install Dir["*"]
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    system "#{bin}/allure", "--help"
  end
end
