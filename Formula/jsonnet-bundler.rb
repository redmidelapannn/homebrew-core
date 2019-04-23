class JsonnetBundler < Formula
  desc "Jsonnet package manager"
  homepage "https://github.com/jsonnet-bundler/jsonnet-bundler"
  url "https://github.com/jsonnet-bundler/jsonnet-bundler/archive/v0.1.0.tar.gz"
  sha256 "7ad25415358b2fd86bac05593ec2e90d9d87df17387fa8fbf4e21b8c06fe9779"

  bottle do
    cellar :any_skip_relocation
    sha256 "b4eaa9b633ddfce4f08f5355eda855b566386000fd546a6f3990c65ad36b8c2b" => :mojave
    sha256 "b231c8189109bda2255ecb8699df75296c1ddf6a630e1a42ade6fca7c8f6e482" => :high_sierra
    sha256 "6862f6484524e9d01cb2ca10fad558c8c8702d4daa01938e5c525037a8a05719" => :sierra
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    (buildpath/"src/github.com/jsonnet-bundler/jsonnet-bundler").install buildpath.children

    cd "src/github.com/jsonnet-bundler/jsonnet-bundler" do
      system "go", "build", "-o", bin/"jb", "-installsuffix", "cgo",
                   "./cmd/jb"
      prefix.install_metafiles
    end
  end

  test do
    output = shell_output("#{bin}/jb 2>&1")
    assert_match "A jsonnet package manager", output
    system bin/"jb", "init"
    assert_match "{}", shell_output("cat jsonnetfile.json 2>&1")
  end
end
