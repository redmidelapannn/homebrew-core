class Sake < Formula
  desc "Automate tasks with Swift"
  homepage "https://github.com/xcodeswift/sake"
  url "https://github.com/xcodeswift/sake/archive/0.4.0.tar.gz"
  sha256 "579a77feeaa4c21653bc74c664a57e3dea61ae5b7275eb55115ea5c7109293ea"
  head "https://github.com/xcodeswift/sake.git"

  bottle do
    sha256 "d4bf52d4773106ad9869ed76a207bff7682b874961278e2be13d0802e39376d4" => :high_sierra
    sha256 "0d0cdb2643cfe32ff97534a6e19684a480b383d967d56c15956950d80d716176" => :sierra
  end

  depends_on :xcode => "9.2"

  def install
    sake_path = "#{buildpath}/.build/release/sake"
    ohai "Building Sake"
    library_path_swift_content = [
      "import Foundation",
      "var librariesPath: String? = \"#{include}\"",
    ].join("\n") + "\n"
    File.write("#{buildpath}/Sources/SakeKit/LibraryPath.swift", library_path_swift_content)
    system("swift build --disable-sandbox -c release")
    bin.install sake_path
    ohai "Installing libraries"
    include.install "#{buildpath}/.build/release/libSakefileDescription.dylib"
    include.install "#{buildpath}/.build/release/SakefileDescription.swiftdoc"
    include.install "#{buildpath}/.build/release/SakefileDescription.swiftmodule"
    include.install "#{buildpath}/.build/release/SwiftShell.swiftdoc"
    include.install "#{buildpath}/.build/release/SwiftShell.swiftmodule"
  end

  test do
    system "#{bin}/sake", "init"
    system "#{bin}/sake", "tasks"
    system "#{bin}/sake", "task", "build"
  end
end
