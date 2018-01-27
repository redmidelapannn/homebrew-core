class GitTracker < Formula
  desc "Integrate Pivotal Tracker into your Git workflow"
  homepage "https://github.com/stevenharman/git_tracker"
  url "https://github.com/stevenharman/git_tracker/archive/v2.0.0.tar.gz"
  sha256 "ec0a8d6dd056b8ae061d9ada08f1cc2db087e13aaecf4e0d150c1808e0250504"

  head "https://github.com/stevenharman/git_tracker.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "06b874569b3473f9670de5d79190cf1b4b82571841cdb5d436f8721f9a5c8e44" => :high_sierra
    sha256 "06b874569b3473f9670de5d79190cf1b4b82571841cdb5d436f8721f9a5c8e44" => :sierra
    sha256 "06b874569b3473f9670de5d79190cf1b4b82571841cdb5d436f8721f9a5c8e44" => :el_capitan
  end

  def install
    system "rake", "standalone:install", "prefix=#{prefix}"
  end

  test do
    output = shell_output("#{bin}/git-tracker help")
    assert_match /git-tracker \d+(\.\d+)* is installed\./, output
  end
end
