class Xchtmlreport < Formula
  desc "XCTestHTMLReport: Xcode-like HTML report for Unit and UI Tests"
  homepage "https://github.com/TitouanVanBelle/XCTestHTMLReport"
  url "https://github.com/TitouanVanBelle/XCTestHTMLReport/archive/1.5.0.tar.gz"
  sha256 "ab8d917c867769693510de50f31d05bd6209875efe29fc1cbdfd344ce5c2ed88"
  head "https://github.com/TitouanVanBelle/XCTestHTMLReport.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "7af1b0113fd45dcfca58a6be209d65b4a6c3ecdd20ab0d0f5192d2a90c30afa7" => :high_sierra
    sha256 "4e7515b06ce2c49a0c7e4771f7a17705fb0e3aa1d0128fc7ebb5b4639067972f" => :sierra
  end

  def install
    system "xcodebuild clean build CODE_SIGN_IDENTITY=\"\" CODE_SIGNING_REQUIRED=NO -workspace XCTestHTMLReport.xcworkspace -scheme XCTestHTMLReport -configuration Release"
    bin.install "xchtmlreport"
  end
end
