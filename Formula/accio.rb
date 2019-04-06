class Accio < Formula
  desc "Dependency manager driven by SwiftPM for iOS/macOS/tvOS/watchOS"
  homepage "https://github.com/JamitLabs/Accio"
  url "https://github.com/JamitLabs/Accio.git", :tag => "0.5.5", :revision => "3b8a910fc4e627c81ffa2e4eafeff450136bb0e4"
  head "https://github.com/JamitLabs/Accio.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "6afc78cb2176ef875a09a5e91a9ef2ff10dfe1b55cb8dcd19b3831e0671c82aa" => :mojave
  end

  depends_on "carthage"
  depends_on :xcode => "10.2"

  def install
    system "make", "install", "prefix=#{prefix}"
  end

  test do
    system bin/"accio", "version"
  end
end
