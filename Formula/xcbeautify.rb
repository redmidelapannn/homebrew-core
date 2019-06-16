class Xcbeautify < Formula
  desc "Little beautifier tool for xcodebuild"
  homepage "https://github.com/thii/xcbeautify"
  url "https://github.com/thii/xcbeautify.git",
      :tag      => "0.4.3",
      :revision => "d7363b1990200996040b5aa79106536aa8b132d3"
  head "https://github.com/thii/xcbeautify.git"
  bottle do
    cellar :any_skip_relocation
    sha256 "1dfa6ee7b27b249879902721b8ea808e0ef538c05f05aae6b32ccbea44a7bbd4" => :mojave
    sha256 "c7e1c05e5a4a63232c620d3b792379cf28bc7795951536f25f017d51db9b49ac" => :high_sierra
  end

  depends_on :xcode => ["10.0", :build]

  def install
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    (testpath/"xcodebuild.log").write "CompileStoryboard /Users/admin/MyApp/MyApp/Main.storyboard (in target: MyApp)"
    assert_match "[\u{1B}[36mMyApp\u{1B}[0m] \u{1B}[1mCompiling\u{1B}[0m Main.storyboard",
      shell_output("cat xcodebuild.log | #{bin}/xcbeautify").chomp
    assert_match version.to_s,
      shell_output("#{bin}/xcbeautify --version").chomp
  end
end
