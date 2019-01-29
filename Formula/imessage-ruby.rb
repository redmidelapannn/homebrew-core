class ImessageRuby < Formula
  desc "Command-line tool to send iMessage"
  homepage "https://github.com/linjunpop/imessage"
  url "https://github.com/linjunpop/imessage/archive/v0.3.1.tar.gz"
  sha256 "74ccd560dec09dcf0de28cd04fc4d512812c3348fc5618cbb73b6b36c43e14ef"
  head "https://github.com/linjunpop/imessage.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "be09a0fd841f1af31f9d9f53346c3e7efdd323b272cae25fd0afe48d7921aed3" => :mojave
    sha256 "6a4ffc6580e2bcda588a6fb41a904f19731ac0e9329807884dc8155e1e724933" => :high_sierra
    sha256 "6a4ffc6580e2bcda588a6fb41a904f19731ac0e9329807884dc8155e1e724933" => :sierra
  end

  def install
    system "rake", "standalone:install", "prefix=#{prefix}"
  end

  test do
    system "#{bin}/imessage", "--version"
  end
end
