class ForkCleaner < Formula
  desc "Cleans up old and inactive forks on your GitHub account"
  homepage "https://github.com/caarlos0/fork-cleaner"
  url "https://github.com/caarlos0/fork-cleaner/archive/v1.4.2.tar.gz"
  sha256 "a3ce478f277e2c2a84661ecf92ad42ffeceb8836bc6e5d182f7fad7b6ec9ddd8"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "408bb104843b110479d04478331cdee05977b96704f22e52c7fcbea86b3bf580" => :high_sierra
    sha256 "71bba9fb28fb8e7995400902409b2912e13491a85ef4b8e1c465e91a9385cce6" => :sierra
    sha256 "096435b38e910743239b8aa270bb1c072625b6f7523f7206521cc217f4c562d7" => :el_capitan
  end

  depends_on "dep" => :build
  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    dir = buildpath/"src/github.com/caarlos0/fork-cleaner"
    dir.install buildpath.children
    cd dir do
      system "dep", "ensure", "-vendor-only"
      system "make"
      bin.install "fork-cleaner"
      prefix.install_metafiles
    end
  end

  test do
    output = shell_output("#{bin}/fork-cleaner 2>&1", 1)
    assert_match "missing github token", output
  end
end
