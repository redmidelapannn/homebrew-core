class Fastlane < Formula
  desc "Easiest way to build and release mobile apps"
  homepage "https://fastlane.tools"
  url "https://github.com/fastlane/fastlane/archive/2.145.0.tar.gz"
  sha256 "56bde1d8a211722eda6ca14b8c3c214326efc85df1f5d9c4a7b71d92e11a3438"
  head "https://github.com/fastlane/fastlane.git"

  bottle do
    cellar :any
    sha256 "0fe1e85489098b6118b23f01c3937c8d6a4de3af12d5f9deef713022c1ca138b" => :catalina
    sha256 "b7b47b617bf05b696d0230852ef000b086845dd7dccd1ad3be0dd7d7e48fcb8d" => :mojave
    sha256 "22110765a2eeb70c8e9d9d62675541e239d826f2ad69cb78d9aec2184ca006c7" => :high_sierra
  end

  depends_on "ruby@2.5"

  def install
    ENV["GEM_HOME"] = libexec
    ENV["GEM_PATH"] = libexec

    system "gem", "build", "fastlane.gemspec"
    system "gem", "install", "fastlane-#{version}.gem", "--no-document"

    (bin/"fastlane").write <<~EOS
      #!/bin/bash
      export PATH="#{Formula["ruby@2.5"].opt_bin}:#{libexec}/bin:$PATH"
      GEM_HOME="#{libexec}" GEM_PATH="#{libexec}" \\
        exec "#{libexec}/bin/fastlane" "$@"
    EOS
    chmod "+x", bin/"fastlane"
  end

  test do
    assert_match "fastlane #{version}", shell_output("#{bin}/fastlane --version")

    actions_output = shell_output("#{bin}/fastlane actions")
    assert_match "gym", actions_output
    assert_match "pilot", actions_output
    assert_match "screengrab", actions_output
    assert_match "supply", actions_output
  end
end
