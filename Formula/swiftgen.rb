class Swiftgen < Formula
  desc "Swift code generator for assets, storyboards, Localizable.strings, …"
  homepage "https://github.com/SwiftGen/SwiftGen"
  url "https://github.com/SwiftGen/SwiftGen.git",
      :tag => "5.3.0-4",
      :revision => "3a698421fe14947cf26e452f5f127d6c3f3ee8de"
  head "https://github.com/SwiftGen/SwiftGen.git"

  bottle do
    cellar :any
    sha256 "f0cc3d6cc2cb47aa23f48982ff7537b521085d556ac508753346b876b9d0080e" => :high_sierra
    sha256 "8dbe8f0321b1af649d1c153d12891bebc2ab1986bbd941a5c1cef42645b90395" => :sierra
  end

  depends_on :xcode => ["9.2", :build]

  def install
    # Disable swiftlint Build Phase to avoid build errors if versions mismatch
    ENV["NO_CODE_LINT"]="1"

    # Install bundler, then use it to `rake cli:install` SwiftGen
    ENV["GEM_HOME"] = buildpath/"gem_home"
    system "gem", "install", "bundler"
    ENV.prepend_path "PATH", buildpath/"gem_home/bin"
    system "bundle", "install", "--without", "development", "release"
    system "bundle", "exec", "rake", "cli:install[#{bin},#{lib},#{pkgshare}/templates]"

    fixtures = {
      "Tests/Fixtures/Resources/XCAssets/Images.xcassets" => "Images.xcassets",
      "Tests/Fixtures/Resources/XCAssets/Colors.xcassets" => "Colors.xcassets",
      "Tests/Fixtures/Resources/Colors/colors.xml" => "colors.xml",
      "Tests/Fixtures/Resources/Strings/Localizable.strings" => "Localizable.strings",
      "Tests/Fixtures/Resources/Storyboards-iOS" => "Storyboards-iOS",
      "Tests/Fixtures/Resources/Fonts" => "Fonts",
      "Tests/Fixtures/Generated/XCAssets/swift3-context-all.swift" => "xcassets.swift",
      "Tests/Fixtures/Generated/Colors/swift3-context-defaults.swift" => "colors.swift",
      "Tests/Fixtures/Generated/Strings/structured-swift3-context-localizable.swift" => "strings.swift",
      "Tests/Fixtures/Generated/Storyboards-iOS/swift3-context-all.swift" => "storyboards.swift",
      "Tests/Fixtures/Generated/Fonts/swift3-context-defaults.swift" => "fonts.swift",
    }
    (pkgshare/"fixtures").install fixtures
  end

  test do
    system bin/"swiftgen", "--version"

    fixtures = pkgshare/"fixtures"

    output = shell_output("#{bin}/swiftgen xcassets --templatePath #{pkgshare/"templates/xcassets/swift3.stencil"} #{fixtures}/Images.xcassets #{fixtures}/Colors.xcassets").strip
    assert_equal output, (fixtures/"xcassets.swift").read.strip, "swiftgen xcassets failed"

    output = shell_output("#{bin}/swiftgen colors --templatePath #{pkgshare/"templates/colors/swift3.stencil"} #{fixtures}/colors.xml").strip
    assert_equal output, (fixtures/"colors.swift").read.strip, "swiftgen colors failed"

    output = shell_output("#{bin}/swiftgen strings --templatePath #{pkgshare/"templates/strings/structured-swift3.stencil"} #{fixtures}/Localizable.strings").strip
    assert_equal output, (fixtures/"strings.swift").read.strip, "swiftgen strings failed"

    output = shell_output("#{bin}/swiftgen storyboards --templatePath #{pkgshare/"templates/storyboards/swift3.stencil"} #{fixtures}/Storyboards-iOS").strip
    assert_equal output, (fixtures/"storyboards.swift").read.strip, "swiftgen storyboards failed"

    output = shell_output("#{bin}/swiftgen fonts --templatePath #{pkgshare/"templates/fonts/swift3.stencil"} #{fixtures}/Fonts").strip
    assert_equal output, (fixtures/"fonts.swift").read.strip, "swiftgen fonts failed"
  end
end
