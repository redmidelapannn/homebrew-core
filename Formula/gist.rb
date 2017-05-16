class Gist < Formula
  desc "Command-line utility for uploading Gists"
  homepage "https://github.com/defunkt/gist"
  url "https://github.com/defunkt/gist/archive/v4.6.0.tar.gz"
  sha256 "3e07146584b3534726a4bcf24f0b02d6b9b3a0e96150200fe2028634b23d3c74"
  head "https://github.com/defunkt/gist.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "bf96c02189b068076ce4a3b655c0a0a17e39d765bc2d7193c817e16593a51879" => :sierra
    sha256 "43fe5437d1804b143729139fa1e45887fb0e0b9d575b7d04fe2d1f3b575c0436" => :el_capitan
    sha256 "43fe5437d1804b143729139fa1e45887fb0e0b9d575b7d04fe2d1f3b575c0436" => :yosemite
  end

  def install
    rake "install", "prefix=#{prefix}"
  end

  test do
    assert_match %r{https:\/\/gist}, pipe_output("#{bin}/gist", "homebrew")
  end
end
