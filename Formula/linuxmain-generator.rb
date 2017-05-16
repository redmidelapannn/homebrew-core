class LinuxmainGenerator < Formula
  desc "A shell command to keep SPM project's tests in sync on OSX and Linux."
  homepage "https://github.com/valeriomazzeo/linuxmain-generator"
  url "https://github.com/valeriomazzeo/linuxmain-generator/archive/0.2.0.tar.gz"
  sha256 "84a7a29ef8680426d52591631610b683c853910c49532ad17d7101bd35ed207b"

  bottle do
    cellar :any_skip_relocation
    sha256 "e89ba298af1233db51f67c7e26058e5f198c048f64971abfd9f18c56a7598e1d" => :sierra
    sha256 "e8df878ead91c6bd71c81d66d9f0ee76860b04e025b58fa87a076dfe39d9e393" => :el_capitan
  end

  def install
    ENV["CC"] = ""
    system "swift", "build", "-c", "release"
    bin.install ".build/release/linuxmain-generator"
  end
  
  test do
    system "#{bin}/linuxmain-generator", "-h"
  end
end
