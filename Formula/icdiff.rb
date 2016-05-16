class Icdiff < Formula
  desc "Improved colored diff"
  homepage "https://github.com/jeffkaufman/icdiff"
  url "https://github.com/jeffkaufman/icdiff/archive/release-1.8.1.tar.gz"
  sha256 "57a2f1164e9cce98e44cba35473203a19034e919a69762589779f54f4612d8f7"

  bottle do
    cellar :any_skip_relocation
    sha256 "14c80ae814b57c1bf5d7ff891788a2d8c72448036694f4f229f92ee791b6a0f7" => :el_capitan
    sha256 "3ac72926d226e30dc52738591da6dc271ea271e4e4e278566b5338c69d6bc5df" => :yosemite
    sha256 "0a925923306c71936f562542f06293dd796606192f90f80aa98038b3bc17aaf3" => :mavericks
  end

  def install
    bin.install "icdiff", "git-icdiff"
  end

  test do
    (testpath/"file1").write "test1"
    (testpath/"file2").write "test2"
    system "#{bin}/icdiff", "file1", "file2"
    system "git", "init"
    system "#{bin}/git-icdiff"
  end
end
