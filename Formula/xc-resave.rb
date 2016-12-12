
class XcResave < Formula
  desc "Force Xcode to re-save a project from command line"
  homepage "https://github.com/cezheng/xc-resave"
  url "https://github.com/alexgarbarev/xc-resave/archive/0.0.1.tar.gz"
  sha256 "cc872a719c324ce4d4c05fc2c489dfdf18ced2a8f4ac07c9000eefc48224620b"

  bottle do
    cellar :any_skip_relocation
    sha256 "8f78bf107d98c18302e03b3f5ad4b2c9e41b06632895965a43175a1a5dbc7270" => :sierra
    sha256 "d217a38fbcb80c5cc8eadf83f896940f92fad43743a4a5794719c2dc2e64ea3d" => :el_capitan
    sha256 "bcc76a341ebeff3e2bb4530dd4f54a84339c959084bd4d598d9291129086283c" => :yosemite
  end

  def install
    system "make"
    bin.install "xc-resave"
  end

end
