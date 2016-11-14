class Eject < Formula
  desc "Generate swift code from Interface Builder xibs"
  homepage "https://github.com/Raizlabs/Eject"
  url "https://github.com/Raizlabs/Eject/archive/0.1.12.tar.gz"
  sha256 "a4dae3d37f780d274f53ed25d9dc1a27d5245289f9b8cbaaf8be71bc9334de18"

  depends_on :xcode => :build

  def install
    xcodebuild
    bin.install "build/Release/eject.app/Contents/MacOS/eject"
    frameworks_path = "build/Release/eject.app/Contents/Frameworks"
    mv frameworks_path, frameworks
  end

  test do
    system "#{bin}/eject"
  end
end
