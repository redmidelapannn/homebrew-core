class LinuxmainGenerator < Formula
  desc "Shell command to keep SPM tests in sync on OSX and Linux."
  homepage "https://github.com/valeriomazzeo/linuxmain-generator"
  url "https://github.com/valeriomazzeo/linuxmain-generator/archive/0.2.0.tar.gz"
  sha256 "84a7a29ef8680426d52591631610b683c853910c49532ad17d7101bd35ed207b"

  bottle do
    cellar :any_skip_relocation
    sha256 "cda671286602cda1dd4ff2cef1576f3dedd1b7d302a51cb8f1922d7fd4447faf" => :sierra
    sha256 "d6935d8169e1cc10490fe7baf9b59954bf088f712e49a3bed3adf7f8e214aab6" => :el_capitan
  end

  def install
    ENV["CC"] = ""
    system "swift", "build", "-c", "release"
    bin.install ".build/release/linuxmain-generator"
  end

  test do
    system "#{bin}/linuxmain-generator", "--help"
  end
end
