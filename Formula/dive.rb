class Dive < Formula
  desc "Tool for exploring each layer in a docker image"
  homepage "https://github.com/wagoodman/dive"
  url "https://github.com/wagoodman/dive.git",
    :tag      => "v0.8.1",
    :revision => "f2ea8b503d3cb06d1be611dcb32f0ef6b161b511"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "f492d25f03d01d3666c8cac31ec84207a17acc49ad2310ac5d8327f8956d8fec" => :mojave
    sha256 "c4cc4eba375479618ae052c7c9c3eca8a71738b575f6a080233fb0839cdf9fb5" => :high_sierra
    sha256 "5b330e166ef632d94eae721eb1c803bedf485c5c3b5ade16ac3bea5f976e796e" => :sierra
  end

  depends_on "go" => :build

  # Remove this patch in the next version.
  patch do
    url "https://github.com/wagoodman/dive/commit/f48715d4c536fdaf0ec57277f2677e4ed8076ad3.patch?full_index=1"
    sha256 "e13be53a71bca7e5393f7a1cdbbcb2691470be9227e384dc7c97b2bb1b49a40c"
  end

  def install
    ENV["GOPATH"] = buildpath

    dir = buildpath/"src/github.com/wagoodman/dive"
    dir.install buildpath.children

    cd dir do
      system "go", "build", "-ldflags", "-s -w -X main.version=#{version}", "-o", bin/"dive"
      prefix.install_metafiles
    end
  end

  test do
    (testpath/"Dockerfile").write <<~EOS
      FROM alpine
      ENV test=homebrew-core
      RUN echo "hello"
    EOS

    assert_match "dive #{version}", shell_output("#{bin}/dive version")
    assert_match "Building image", shell_output("CI=true #{bin}/dive build .", 1)
  end
end
