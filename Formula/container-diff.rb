class ContainerDiff < Formula
  desc "Diff your Docker containers"
  homepage "https://github.com/GoogleCloudPlatform/container-diff"
  url "https://github.com/GoogleCloudPlatform/container-diff/archive/v0.6.2.tar.gz"
  sha256 "a3c680799c230d2a2352eb1e5765bd6774182b213a73e5c0bf1e6254008cd434"

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    (buildpath/"src/github.com/GoogleCloudPlatform").mkpath
    ln_sf buildpath, buildpath/"src/github.com/GoogleCloudPlatform/container-diff"

    cd "src/github.com/GoogleCloudPlatform/container-diff" do
      system "make"
      bin.install "out/container-diff"
    end
  end

  test do
    output = shell_output("#{bin}/container-diff analyze docker/whalesay 2>&1")
    assert_match /gcc.*ubuntu/, output
  end
end
