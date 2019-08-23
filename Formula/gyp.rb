class Gyp < Formula
  desc "Meta-Build system: a build system that generates other build systems"
  homepage "https://gyp.gsrc.io"
  url "https://chromium.googlesource.com/external/gyp", :using => :git
  bottle do
    cellar :any_skip_relocation
    sha256 "65767051a16a27d335e947d6174467eeaf0c146a9a517d58992d26d0bcb3c153" => :mojave
    sha256 "65767051a16a27d335e947d6174467eeaf0c146a9a517d58992d26d0bcb3c153" => :high_sierra
    sha256 "1c115fe52d5d28d963fadf885f302558e66586b72461a6fcaff4c354e368e91e" => :sierra
  end

  version "1.0" # gyp doesn't actually have any published versions.

  depends_on "python"

  def install
    system "python3", "setup.py", "install", "--prefix=#{prefix}", "--single-version-externally-managed", "--record=installed.txt"

    bin.install("gyp")
    bin.install("gyp_main.py") # gyp is a bash script that executes gyp_main.py.
  end

  test do
    system "#{bin}/gyp", "--help"
  end
end
