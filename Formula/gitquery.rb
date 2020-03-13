class Gitquery < Formula
  desc "Query, Copy and Sync files from a remote Git repo"
  homepage "https://github.com/Tinder/GitQuery"
  url "https://github.com/Tinder/GitQuery/archive/0.0.1.tar.gz"
  sha256 "44975ba05cdfdcf70541e762537cadfc643d110ea6dc8095deaf14dd8148cb35"

  bottle do
    cellar :any_skip_relocation
    sha256 "4f540f70ca74255a6eb4778da9b561a7b2014839b7ac60a7703850c7d01b26c1" => :catalina
    sha256 "ce095b6897141637533c7e2ad69bda54bf6dabe3f512cb3b61af70d5477f2cb3" => :mojave
    sha256 "22f0fb2b3299c8c442f828d65bd20d1db1453f6deb75177caf71e0bf99b0d2e7" => :high_sierra
  end

  depends_on :java => "1.8"

  def install
    system "./gradlew", "installDist"
    libexec.install %w[cli core]
    (bin/"gitquery").write_env_script libexec/"cli/build/install/cli/bin/cli", Language::Java.java_home_env
  end

  test do
    system libexec/"cli/build/install/cli/bin/cli", "--help"
  end
end
