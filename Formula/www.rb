class Www < Formula
    desc "HTTPS? static web server"
  bottle do
    cellar :any_skip_relocation
    sha256 "414b0bf6fb33f6cd3ce92dee07f31df60e407d45148bf71df02080775f7661b4" => :mojave
    sha256 "847ff1501f01d09e288dec298a2d4ec861ee1c1d7a30ff197659ca772b0a8b39" => :high_sierra
    sha256 "00510498c03a7b9cc19accd1ac42b80be44110895317c88e2065429a08879b51" => :sierra
  end

    homepage "https://github.com/nbari/www"
    url "https://github.com/nbari/www.git",
        :tag => "1.1.1",
        :revision => "88e655e483e714d45fdcca1a5054c69d04cab75c"
  
    head "https://github.com/nbari/www.git"
  
    depends_on "go" => :build
    depends_on "dep" => :build
  
    def install
      ENV["GOPATH"] = buildpath
      (buildpath/"src/github.com/nbari/www").install buildpath.children
      cd "src/github.com/nbari/www" do
        system "dep", "ensure"
        ldflags = "-s -w"
        system "go", "build", "-ldflags", ldflags, "-o", "#{bin}/www"
        prefix.install_metafiles
      end
    end
  
    test do
      system bin/"www", "-h"
    end
  end