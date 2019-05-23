class Wtfutil < Formula
  desc "The personal information dashboard for your terminal"
  homepage "https://wtfutil.com"
  url "https://github.com/wtfutil/wtf/archive/v0.10.3.tar.gz"
  sha256 "8afa15a5729bfa5a8d009e3d03423cf7472e797740b92e6f3e66ca8fd05c8454"

  depends_on "go" => :build

  def install
    # ENV["GOPATH"] = buildpath
    ENV["GOPATH"] = HOMEBREW_CACHE/"go_cache"

    dir = buildpath/"src/github.com/wtfutil/wtf"
    dir.install buildpath.children

    cd dir do
      system "go", "build", "-o", bin/"wtf"
      prefix.install_metafiles
    end
  end

  test do
    system "#{bin}/wtf", "-p", "brew"
  end
end
