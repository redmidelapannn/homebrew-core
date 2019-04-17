class Xcbeautify < Formula
  desc "Little beautifier tool for xcodebuild"
  homepage "https://github.com/thii/xcbeautify"
  url "https://github.com/thii/xcbeautify.git",
      :tag      => "0.4.1",
      :revision => "aa8b8795c9309c36d138bada74a73d1b8b16cda8"
  head "https://github.com/thii/xcbeautify.git"
  bottle do
    cellar :any_skip_relocation
    sha256 "638ce635664c129783066cabdd36f60a44a33417cf581d8ee3ca7f8423fb0b23" => :mojave
  end

  depends_on :xcode => ["10.2", :build]

  def install
    if MacOS.full_version < "10.14.4"
      odie "macOS 10.14.4 or above is require to build xcbeautify."
    end

    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    system "#{bin}/xcbeautify", "--help"
  end
end
