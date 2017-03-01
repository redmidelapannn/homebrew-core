class Functions < Formula
  desc "The serverless microservices platform."
  homepage "https://github.com/iron-io/functions"
  url "https://github.com/iron-io/functions/archive/0.2.25.tar.gz"
  sha256 "9c26678e7a7c9606a5c8fc32288624dccb2efbb493ed8747550b8f4faa7d449a"

  bottle do
    cellar :any_skip_relocation
    sha256 "27247e725a40416bb1ccc9c57695ecabfcc4d9dd981636962d8e02318085e0dc" => :sierra
    sha256 "5f5140090856f68d25d5c4be169511ae61595e1a6983a2aafa21818c4aad0280" => :el_capitan
    sha256 "fd23da31c17c4e626f515f0639dc012d9ec64a5e517c2438e1e2aa20612c183c" => :yosemite
  end

  depends_on "go" => :build
  depends_on "glide" => :build

  def install
    ENV["GOPATH"] = buildpath
    ENV["GLIDE_HOME"] = HOMEBREW_CACHE/"glide_home/#{name}"
    dir = buildpath/"src/github.com/iron-io/functions"
    dir.install Dir["*"]
    cd dir do
      system "make"
      system "go", "build", "-o", bin/"fn-server"
      cd "fn"
      system "glide", "install", "-v"
      system "go", "build", "-o", bin/"fn"
    end
  end

  test do
    system bin/"fn-server", "-help"
  end
end
