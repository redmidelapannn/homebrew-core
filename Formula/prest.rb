class Prest < Formula
  desc "Serve a RESTful API from any PostgreSQL database"
  homepage "https://github.com/prest/prest"
  url "https://github.com/prest/prest/archive/v0.3.2.tar.gz"
  sha256 "0f94816eddf0149aecd69f8f321eed166aa4252423545d5887f0cd0351df6829"

  bottle do
    cellar :any_skip_relocation
    sha256 "b160feb2f71dc27319ee3a50366e726cf3939e0dfc21e5001d64113044b45b5d" => :high_sierra
    sha256 "118386914e62b0cd297c8646a69e5c082c4cf1fccb8ecc9f76743802d4a3f09b" => :sierra
    sha256 "2dfc5c57a8010aca0d41ea8da633931d6f7ef4524c3f8690932036880e0b0b18" => :el_capitan
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    (buildpath/"src/github.com/prest/prest").install buildpath.children
    cd "src/github.com/prest/prest" do
      system "go", "build", "-o", bin/"prest"
      prefix.install_metafiles
    end
  end

  test do
    system "#{bin}/prest", "version"
  end
end
