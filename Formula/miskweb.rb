class Miskweb < Formula
  desc "CLI for managing Misk-Web projects"
  homepage "https://github.com/square/misk-web/"

  version "0.1.3"

  os = `uname`

  if os == "Linux"
    stable do
      url 'https://github.com/square/misk-web/raw/master/misk-web/web/packages/@misk/cli/bin/linux/miskweb', :using => :curl
    end
  bottle do
    cellar :any_skip_relocation
    sha256 "b5526628fad4a0bd370f8c2aa5a0bde4d360887eafece3cfd0b2fc3b9daf1e38" => :mojave
    sha256 "a53378d96180818a66b578e8d4c91110cdcceb3dcb7f934e86aed38a3f07da4d" => :high_sierra
    sha256 "86797dd4891f835167ffe503d6a81c5c02bbfcd91aa5aedf0eae6508c9b30944" => :sierra
  end

  else
    stable do
      url 'https://github.com/square/misk-web/raw/master/misk-web/web/packages/@misk/cli/bin/macos/miskweb', :using => :curl
    end
  end

  def install
    bin.install 'miskweb'
  end
end
