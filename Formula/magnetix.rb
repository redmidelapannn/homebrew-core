class Magnetix < Formula
  desc "Interpreter for Magnetic Scrolls adventures"
  homepage "http://www.maczentrisch.de/magnetiX/"
  url "http://www.maczentrisch.de/magnetiX/downloads/magnetiX_src.zip"
  version "3.1"
  sha256 "9862c95659c4db0c5cbe604163aefb503e48462c5769692010d8851d7b31c2fb"

  bottle do
    cellar :any_skip_relocation
    sha256 "5347d78303968e47265e506bd52b7e9a8bf29bd4e9a55c486a4cdd6edb64e387" => :yosemite
  end

  depends_on :xcode => :build

  def install
    cd "magnetiX_src" do
      xcodebuild
      prefix.install "build/Default/magnetiX.app"
      bin.write_exec_script "#{prefix}/magnetiX.app/Contents/MacOS/magnetiX"
    end
  end

  def caveats; <<-EOS.undent
    Install games in the following directory:
      ~/Library/Application Support/magnetiX/
    EOS
  end

  test do
    File.executable? "#{prefix}/magnetiX.app/Contents/MacOS/magnetiX"
  end
end
