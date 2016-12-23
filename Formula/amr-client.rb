class AmrClient < Formula
  desc "Ask Mr. Robot Simulator Client"
  homepage "http://www.askmrrobot.com/"
  url "https://static2.askmrrobot.com/amrbeta/client/AskMrRobotClient-159-osx.10.11-x64.zip"
  version "159"
  sha256 "53346959796c7f25038d17eccd5f21a56bbadd9d80f0c90387bcce01db8addd5"

  bottle do
    cellar :any
    sha256 "e498b534e5dc50b2987b31bb45b6ec1d59f7625c3d6b360a3080806dd6693cb1" => :sierra
    sha256 "8e260f68befb1830354404ea000dd4c48622d366f682dd1985cc88c048a7cd47" => :el_capitan
    sha256 "1a3cba711bec95f9a3b53180132449315f08e12095931614cd11a45ef26248cc" => :yosemite
  end

  def install
    chmod 0755, "updater/amrupdate"
    chmod 0755, "client/amr"
    libexec.install Dir["*"]
    bin.install_symlink libexec/"updater/amrupdate"
    bin.install_symlink libexec/"client/amr"
  end

  test do
    system "if [[ -x `which amr` ]]; then true; else false; fi"
    system "if [[ -x `which amrupdate` ]]; then true; else false; fi"
  end
end
