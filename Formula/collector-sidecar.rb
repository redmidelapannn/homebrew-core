class CollectorSidecar < Formula
  desc "Manage log collectors through Graylog"
  homepage "https://github.com/Graylog2/collector-sidecar"
  url "https://github.com/Graylog2/collector-sidecar/archive/0.1.0-rc.1.tar.gz"
  sha256 "23e02ba030fc9572be798acf90e121da9ccde312d0db79245d06f8f87a070af7"

  bottle do
    sha256 "8e21c8e28203fe83dd54c47235ce78b753374cd5df4e1e24a39422fc5ea0d3b8" => :sierra
    sha256 "a7cbe9d57f5c0dea8d0b6b215ec623dbbdb2c0f5d0843173e12e91c8567a68e9" => :el_capitan
    sha256 "6fad33f5e55a95b53637bda15ec47ed486b94cdbfd1edfd14e48a4e957e1a032" => :yosemite
  end

  depends_on "glide" => :build
  depends_on "go" => :build
  depends_on :hg => :build
  depends_on "filebeat" => :run

  def install
    ENV["GOPATH"] = buildpath
    ENV["GLIDE_HOME"] = HOMEBREW_CACHE/"glide_home/#{name}"
    (buildpath/"src/github.com/Graylog2/collector-sidecar").install buildpath.children
    cd "src/github.com/Graylog2/collector-sidecar" do
      inreplace "main.go", "/etc", etc
      inreplace "collector_sidecar.yml", "/usr", HOMEBREW_PREFIX
      inreplace "collector_sidecar.yml", "/etc", etc
      inreplace "collector_sidecar.yml", "/var", var
      system "glide", "install"
      system "make", "build"
      (etc/"graylog/collector-sidecar").install "collector_sidecar.yml"
      bin.install "graylog-collector-sidecar"
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/graylog-collector-sidecar -version")
  end
end
