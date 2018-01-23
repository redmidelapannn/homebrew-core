class ContainerDiff < Formula
  desc "Diff your Docker containers"
  homepage "https://github.com/GoogleCloudPlatform/container-diff"
  url "https://github.com/GoogleCloudPlatform/container-diff/archive/v0.5.2.tar.gz"
  sha256 "9f64267b01e9f96efd053eadbac6435bdb15c05597e8ebe4e7081e13fb7e45cf"

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
    output = shell_output("#{bin}/container-diff analyze docker/whalesay")
    assert_match /gcc.*ubuntu/, output
  end
end
