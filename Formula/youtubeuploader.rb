class Youtubeuploader < Formula
  desc "Scripted uploads to Youtube"
  homepage "https://github.com/porjo/youtubeuploader"
  url "https://github.com/porjo/youtubeuploader/archive/18.12.tar.gz"
  sha256 "c76fa3c1a021d38a1faf6ba46479b11888bdc892bff1a7e8902a8b4c2dc5d875"

  bottle do
    cellar :any_skip_relocation
    sha256 "b8f55140a7ba86445f7172165447830e4ba50f53506ba25f68b0dd564ca439ef" => :mojave
    sha256 "0b4066109b74ecdd43451badd03a9974066dc2be4cf831bf939eb515ddacc441" => :high_sierra
    sha256 "2004e75ee9c3e2987c9962a633e8ba383257002b470c59e1a5827b44af8a98ed" => :sierra
    sha256 "2586241ef9892c59d0f3f1f185cb81fb94f9caea4ffe686e1f14617f934a6088" => :el_capitan
  end

  depends_on "dep" => :build
  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    path = buildpath/"src/github.com/porjo/youtubeuploader"
    path.install Dir["*"]
    cd path do
      system "dep", "ensure", "-vendor-only"
      system "go", "build", "-a", "-ldflags", "-s -X main.appVersion=#{version}", "-o", "#{bin}/youtubeuploader"
      prefix.install_metafiles
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/youtubeuploader -v")
  end
end
