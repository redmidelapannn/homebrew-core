class Allure < Formula
  desc "Flexible lightweight test report tool"
  homepage "https://github.com/allure-framework"
  url "https://dl.bintray.com/qameta/generic/io/qameta/allure/allure/2.0.1/allure-2.0.1.tgz"
  sha256 "315f2a9e963ce6293075149b15ed11423ac3709adb03658d1b16ed59bafcaa6e"

  depends_on :java => "1.8"

  def install
    # Remove all windows files
    rm_f Dir["bin/*.bat"]

    prefix.install_metafiles
    libexec.install Dir["*"]
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    system "#{bin}/allure", "help"
  end
end
