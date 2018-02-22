class Layer0 < Formula
  desc "Framework that helps you deploy to the AWS with minimal fuss"
  homepage "http://layer0.ims.io"
  url "https://github.com/quintilesims/layer0/archive/v0.10.6.tar.gz"
  sha256 "9612109680d42106a9f26ed1a5d7d2d5a8cf55219b895a535bb73058dacb51d1"
  bottle do
    cellar :any_skip_relocation
    sha256 "4f6d749a4db863000b4f6a48513e25e8cf0522b1d726db6b069ef17ba932f4ef" => :high_sierra
    sha256 "3b45ca492ddaf755cc01426d6fb730300f05cfea8933c0588e856cb325f40f32" => :sierra
    sha256 "247dee52772a297d1371f08a0c9f9ede7bac6c9ae02a7d2588c9d4d0a9164b10" => :el_capitan
  end

  depends_on "terraform"
  depends_on "go" => :build
  def install
    ENV["GOPATH"] = buildpath
    (buildpath/"src/github.com/quintilesims/layer0").install Dir["*"]
    cd "src/github.com/quintilesims/layer0/cli" do
      system "go", "build", "-ldflags", "-s -X main.Version=v0.10.6", "-a", "-o", bin/"l0", "main.go"
    end
    cd "src/github.com/quintilesims/layer0/setup" do
      system "go", "build", "-ldflags", "-s -X main.Version=v0.10.6", "-a", "-o", bin/"l0-setup", "main.go"
    end
  end  
  test do
    system "#{bin}/l0", "--version"
    system "#{bin}/l0-setup", "--version"
  end
end
