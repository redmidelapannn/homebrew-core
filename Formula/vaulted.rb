class Vaulted < Formula
  desc "Allows the secure storage and execution of environments"
  homepage "https://github.com/miquella/vaulted"
  url "https://github.com/miquella/vaulted/archive/v2.4.1.tar.gz"
  sha256 "babb2d076476ba477d545da1291918bb73e96668409c9b966c28ad20890c0eb9"
  head "https://github.com/miquella/vaulted.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "1523cc6171d4209f2bbedc28d271465a8d15e88bdfa019fbcb60449ae9e93134" => :mojave
    sha256 "e0cfc8a8d16995d0ccb2ab01c64c254760b1e78fea6a1ae9665a9bbd72a73a13" => :high_sierra
    sha256 "87141bb1f74b1fcb8bc03b5f6f038504c05465377d394894b48c505e7b2c9768" => :sierra
  end

  depends_on "go" => :build

  def install
    system "go", "build", "-o", bin/"vaulted", "."
    man1.install Dir["doc/man/vaulted*.1"]
  end

  test do
    (testpath/".local/share/vaulted").mkpath
    touch(".local/share/vaulted/test_vault")
    output = IO.popen(["#{bin}/vaulted", "ls"], &:read)
    output == "test_vault\n"
  end
end
